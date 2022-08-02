# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  private

  # ログイン済みユーザーか確認する
  def logged_in_user
    redirect_to login_url unless logged_in?
  end
end
