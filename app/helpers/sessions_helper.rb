# frozen_string_literal: true

# ログイン/ログアウト処理に関するhelper
module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 記憶トークンに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id]) # 代入してセッションのユーザーIDがあるか
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end

  # ユーザーがログインしていればtrue、その他はfalseを返す
  def logged_in?
    !current_user.nil?
  end
end
