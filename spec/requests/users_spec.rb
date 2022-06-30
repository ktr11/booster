# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /signup/' do
    it '200になり想定どおりの文字列が含まれる' do
      get '/signup/'
      expect(response).to have_http_status(200)
      expect(response.body).to match(%r{ユーザー名})
      expect(response.body).to match(%r{メールアドレス})
      expect(response.body).to match(%r{パスワード})
      expect(response.body).to include('パスワード(確認)')
    end
  end
end
