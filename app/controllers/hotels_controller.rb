class HotelsController < ApplicationController
  before_action :authenticate

  def index
    @hotels = Hotel.all
  end

  def show
    render_forbidden unless is_user_hotel_manager?(params[:id])
    HotelViewsCountJob.perform_later(params[:id])
    @hotel = Hotel.find(params[:id])
    render :json => @hotel, status: 200
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(hotel_params)

    if @hotel.save
      authenticate_with_http_token do |token, options|
        user = User.find_by(token: token)
        user.managers.create(hotel: @hotel)
      end
      redirect_to @hotel
    else
      render 'new'
    end
  end

  def edit
    render_forbidden unless is_user_hotel_manager?(params[:id])
    @hotel = Hotel.find(params[:id])
  end

  def update
    render_forbidden unless is_user_hotel_manager?(params[:id])
    @hotel = Hotel.find(params[:id])
    if @hotel.update(hotel_params)
      redirect_to @hotel
    else
      render 'edit'
    end
  end

  def destroy
    render_forbidden unless is_user_hotel_manager?(params[:id])
    @hotel = Hotel.find(params[:id])
    @hotel.destroy
    redirect_to hotels_path
  end

  private
  def hotel_params
    params.require(:hotel).permit(:name, :description, :country_code, :average_price)
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
      if user.manager
        submitted_hotel = Hotel.find(hotel)
        user.hotels.include?(submitted_hotel)
      end
    end
  end

end
