# frozen_string_literal: true

# User登録、編集処理のcontroller
class UsersController < ApplicationController
  before_action :correct_user,   only: %i[edit update]

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

  # ユーザー詳細画面
  def show
    @user = User.find(params[:id])
  end

  # User編集 初期表示
  def edit; end

  # User更新
  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  # パラメータの制限処理
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
