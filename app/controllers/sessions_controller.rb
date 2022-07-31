# frozen_string_literal: true

# ログイン/ログアウト処理に関するcontroller
class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email].downcase)
    if @user&.authenticate(params[:password])
      log_in(@user)
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスとパスワードが一致しません。'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
