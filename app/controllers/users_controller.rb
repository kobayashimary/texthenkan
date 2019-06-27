class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :documents_ichiran]
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to login_url
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  def documents_ichiran
    @user = User.find(params[:id])
    @documents = @user.documents.page(params[:page])
  end
  def edit
    @user = User.find(params[:id])
  end

  def update
      
    @user = User.find(params[:id])
      
    if @user.update(user_params)
      flash[:success] = 'プロフィール画像 は正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'プロフィール画像 は更新されませんでした'
      render :edit
    end
  end
  
def destroy
  @user = User.find(params[:id])
  @nil=nil
  @user.update(thumb: @nil)
  flash[:success] = 'プロフィール画像 は正常に更新されました'
  redirect_to root_url
end
   

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,:thumb)
  end
end
