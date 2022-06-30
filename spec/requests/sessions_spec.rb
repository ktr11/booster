# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:title_top) { 'booster' }
  let!(:user) { create(:user, email: 'hoge@example.com', password: 'password1') }

  describe 'GET /login/' do
    it '200になり想定どおりの文字列が含まれる' do
      get '/login/'
      expect(response).to have_http_status(200)
      expect(response.body).to match(%r{<title>#{title_top}</title>})
      expect(response.body).to match(%r{booster})
      expect(response.body).to match(%r{メールアドレス})
      expect(response.body).to match(%r{パスワード})
    end
  end

  describe 'POST /login/create' do
    it 'emailとpasswordが一致している' do
      post '/login/create', params: { email: 'hoge@example.com', password: 'password1' }
      expect(response).to have_http_status(302)
      is_expected.to redirect_to('/')
      expect(session[:user_id]).to_not eq nil
      get '/'
      expect(response.body).to include('ログイン済')
    end
    it 'emailとpasswordが不一致' do
      post '/login/create', params: { email: 'hoge@example.com', password: 'password2' }
      expect(response).to have_http_status(200)
      expect(response.body).to include('メールアドレスとパスワードが一致しません')
      expect(session[:user_id]).to eq nil
    end
    it 'emailが存在しない' do
      post '/login/create', params: { email: 'hoge9999@example.com', password: 'password2' }
      expect(response).to have_http_status(200)
      expect(response.body).to include('メールアドレスとパスワードが一致しません')
      expect(session[:user_id]).to eq nil
    end
  end
end
