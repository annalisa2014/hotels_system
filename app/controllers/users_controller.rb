class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    render :json => @user, status: 200
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = @user.crypt_password(params['user']['password'])
    if @user.save
      puts "Account Created Successfully"
      render :json => @user, status: 200
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to hotels_path
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :language)
  end
end
