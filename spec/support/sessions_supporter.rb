# frozen_string_literal: true

# ログイン/ログアウト処理のテストに関するsupporter
module SessionsSupporter
  # 渡されたユーザーでログインする
  def login_as(user)
    post '/login/create', params: { email: user.email, password: user.password }
  end
end

RSpec.configure do |config|
  config.include SessionsSupporter
end
