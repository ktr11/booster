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
  describe 'POST /signup/' do
    it 'name,email,passwordが正しい場合、User登録成功' do
      user_count = User.count
      post '/signup/', params: {
        user: {
          name: 'test1',
          email: 'test1@example.com',
          password: 'testpass1',
          password_confirmation: 'testpass1'
        }
      }
      expect(response).to have_http_status(302)
      is_expected.to redirect_to('/')
      expect(session[:user_id]).to_not eq nil
      get '/'
      expect(response.body).to include('ログイン済')
      expect(response.body).to include('ユーザー登録が完了しました')
      user = User.find_by(email: 'test1@example.com')
      expect(user).to_not eq nil
      expect(user_count + 1).to eq User.count
    end
    it 'nameが空の場合、User登録失敗' do
      user_count = User.count
      post '/signup/', params: {
        user: {
          name: '',
          email: 'test1@example.com',
          password: 'testpass1',
          password_confirmation: 'testpass1'
        }
      }
      expect(response).to have_http_status(200)
      expect(session[:user_id]).to eq nil
      expect(response.body).to include('ユーザー名を入力してください')
      expect(user_count).to eq User.count
    end
    it 'emailが空の場合、User登録失敗' do
      user_count = User.count
      post '/signup/', params: {
        user: {
          name: 'test1',
          email: '',
          password: 'testpass1',
          password_confirmation: 'testpass1'
        }
      }
      expect(response).to have_http_status(200)
      expect(session[:user_id]).to eq nil
      expect(response.body).to include('メールアドレスを入力してください')
      expect(user_count).to eq User.count
    end
    it 'passwordが空の場合、User登録失敗' do
      user_count = User.count
      post '/signup/', params: {
        user: {
          name: 'test1',
          email: 'test1@example.com',
          password: '',
          password_confirmation: 'testpass1'
        }
      }
      expect(response).to have_http_status(200)
      expect(session[:user_id]).to eq nil
      expect(response.body).to include('パスワードを入力してください')
      expect(user_count).to eq User.count
    end
    it 'password_confirmが空の場合、User登録失敗' do
      user_count = User.count
      post '/signup/', params: {
        user: {
          name: 'test1',
          email: 'test1@example.com',
          password: 'testpass1',
          password_confirmation: ''
        }
      }
      expect(response).to have_http_status(200)
      expect(session[:user_id]).to eq nil
      expect(response.body).to include('パスワード(確認)とパスワードの入力が一致しません')
      expect(user_count).to eq User.count
    end
  end
end
