class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  protected
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      User.find_by(token: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render :json => 'Bad credentials', status: 401
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def header_language_to_currency
    header_lang = extract_locale_from_accept_language_header
    case header_lang
      when 'es'
        'USD'
      when 'en'
        'GBP'
      else
        'EUR'
    end
  end

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
  end
end
