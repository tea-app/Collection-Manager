class UserController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only:[:show, :edit, :update]
  def show
  end
  
  def edit
  end
  
  def update
      file = params[:user][:image]
      @user.set_image(file)
      
      if @user.update(user_params)
          redirect_to @user, notice: 'ユーザー情報が更新されました'
          else
          render :edit
      end
  end
  
  private
  
  def set_user
     @user = User.find(params[:id])
  end
  
  def user_params
      params.require(:user).permit(:name, :email)
  end
end
