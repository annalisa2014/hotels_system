class UsersController < ApplicationController
  before_action :authenticate, except: [:new, :create]

  def index
    render :json => User.all, status: 200
  end

  def show
    render :json => User.find(params[:id]), status: 200
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      puts "Account Created Successfully"
      render :json => @user.token, status: 200
    else
      render :json => error_list(@user.errors), status: 403
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      render :json => @user, status: 200
    else
      render :json => error_list(@user.errors), status: 403
    end
  end

  def destroy
    @user = User.find(params[:id])
    msg = "User #{@user.id}, #{@user.email} deleted"
    @user.destroy
    render :json => msg, status: 200
  end

  private
  def user_params
    params.permit(:first_name, :last_name, :email, :password, :language)
  end
end
