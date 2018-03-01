class LoginController < ApplicationController

  def index
  end

  def login
    @user = User.find_by_email params['email']
    if @user.password_correct? params['password']
      token = @user.generate_token_if_loggedin params['password']
      render :json => token, status: 200
    else
      render :json => 'Bad credentials', status: 401
    end
  end

end
