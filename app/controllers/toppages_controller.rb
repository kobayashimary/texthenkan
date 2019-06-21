class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @documents = current_user.documents.order(id: :desc).page(params[:page])
    end
  end
end
