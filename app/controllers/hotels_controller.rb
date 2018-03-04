class HotelsController < ApplicationController
  before_action :authenticate

  def index
    user = nil
    authenticate_with_http_token do |token, options|
      user = User.find_by(token: token)
    end
    render :json => user.hotels, status: 200
  end

  def show
    render_forbidden and return unless is_user_hotel_manager?(params[:id])

    HotelViewsCountJob.perform_later(params[:id])
    @hotel = Hotel.find(params[:id])
    currency = @hotel.header_language_to_currency extract_locale_from_accept_language_header
    @hotel.average_price = @hotel.to_currency(currency)
    render :json => @hotel, status: 200
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(hotel_params)
    amount = params[:average_price]
    currency = @hotel.header_language_to_currency extract_locale_from_accept_language_header
    @hotel.average_price = @hotel.to_euro(amount, currency)
    if @hotel.save
      authenticate_with_http_token do |token, options|
        user = User.find_by(token: token)
        user.add_managed_hotel @hotel
      end
      render :json => @hotel, status: 200
    else
      render :json => error_list(@hotel.errors), status: 400
    end
  end

  def edit
    render_forbidden and return unless is_user_hotel_manager?(params[:id])
    @hotel = Hotel.find(params[:id])
  end

  def update
    render_forbidden and return unless is_user_hotel_manager?(params[:id])
    @hotel = Hotel.find(params[:id])
    if @hotel.update(hotel_params)
      render :json => @hotel, status: 200
    else
      render :json => error_list(@hotel.errors), status: 400
    end
  end

  def destroy
    render_forbidden and return unless is_user_hotel_manager?(params[:id])
    @hotel = Hotel.find(params[:id])
    msg = "Hotel #{@hotel.id}, #{@hotel.name} deleted"
    @hotel.destroy
    render :json => msg, status: 200
  end

  def header_lang
    lang = extract_locale_from_accept_language_header
    render :json => lang
  end

  private
  def hotel_params
    params.permit(:name, :description, :country_code, :average_price)
  end

  def render_forbidden
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render :json => 'Bad credentials', status: 403
  end

  def validate_user
    authenticate_user_by_hotel || render_forbidden
  end

  def is_user_hotel_manager?(hotel)
    authenticate_with_http_token do |token, options|
      user = User.find_by(token: token)
      user.is_hotel_manager?(hotel)
    end
  end
end
