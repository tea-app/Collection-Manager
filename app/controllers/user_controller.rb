class UserController < ApplicationController
    include UserHelper
    before_action :authenticate_user!
    before_action :set_user, only:[:show, :edit, :update]
  def show
      @books_h = Library.where(["mode = ? and user_id = ?", 0, current_user.id])
      @books_r = Library.where(["mode = ? and user_id = ?", 1, current_user.id])
      @books_have = []
      @books_read = []
      if @books_h.nil?
          else
          for i in 0..(@books_h.size - 1) do
              @books_have[i] = api(@books_h[i].isbn)
          end
      end
      if @books_r.nil?
          else
          for i in 0..(@books_r.size - 1) do
              @books_read[i] = api(@books_r[i].isbn)
          end
      end
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
