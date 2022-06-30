# frozen_string_literal: true

# User登録、編集処理のcontroller
class UsersController < ApplicationController
  # ユーザー登録画面の初期表示
  def new
    @user = User.new
  end
end
