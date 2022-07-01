# frozen_string_literal: true

# User登録、編集処理のcontroller
class UsersController < ApplicationController
  # ユーザー登録画面の初期表示
  def new
    @user = User.new
  end

  # ユーザー登録処理
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = 'ユーザー登録が完了しました。'
      log_in(@user)
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

  # パラメータの制限処理
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
