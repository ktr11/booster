# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  # ユーザー登録画面初期表示
  describe 'GET /signup/' do
    it '200になり想定どおりの文字列が含まれる' do
      get '/signup/'
      expect(response).to have_http_status(200)
      expect(response.body).to include('ユーザー名')
      expect(response.body).to include('メールアドレス')
      expect(response.body).to include('パスワード')
      expect(response.body).to include('パスワード(確認)')
    end
  end
  # ユーザー登録画面登録処理
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
  # ユーザー詳細画面初期表示
  describe 'GET /users/{user_id}' do
    it 'ユーザー詳細画面表示、200であり、必要な情報が表示されていればOK' do
      user = create(:user)
      get "/users/#{user.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to include(user.name)
    end
  end
  # ユーザー編集画面初期表示
  describe 'GET /users/edit/{user_id}' do
    it 'ユーザー編集画面表示、200であり、必要な情報が表示されていればOK' do
      user = create(:user)
      login_as(user)
      get "/users/#{user.id}/edit"
      expect(response).to have_http_status(200)
      expect(response.body).to include(user.name)
      expect(response.body).to include(user.email)
      expect(response.body).to include('ユーザー名')
      expect(response.body).to include('メールアドレス')
      expect(response.body).to include('パスワード')
      expect(response.body).to include('パスワード(確認)')
    end
    it 'ユーザー編集画面表示、ログイン中ユーザーでない場合、rootにリダイレクト' do
      user1 = create(:user)
      user2 = create(:user)
      login_as(user1)
      get "/users/#{user2.id}/edit"
      is_expected.to redirect_to('/')
    end
  end
  # ユーザー更新
  describe 'PATCH /users/{user_id}' do
    it 'ユーザー更新処理、200であり、必要な情報が表示されていればOK' do
      user = create(:user)
      login_as(user)
      patch "/users/#{user.id}/",
            params: {
              user: {
                name: 'geho',
                email: 'geho@example.com',
                password: 'password2',
                password_confirmation: 'password2'
              }
            }
      expect(response).to have_http_status(302)
      is_expected.to redirect_to("/users/#{user.id}")
      get "/users/#{user.id}"
      expect(response.body).to include('geho')
      expect(response.body).to include('ユーザー名')
      # 新しいemailとpasswordでログインできること。
      post '/login/create', params: { email: 'geho@example.com', password: 'password2' }
      is_expected.to redirect_to('/')
    end
    it 'ユーザー更新処理、ログイン中ユーザーでない場合、rootにリダイレクト' do
      user1 = create(:user)
      user2 = create(:user)
      login_as(user1)
      patch "/users/#{user2.id}/",
            params: {
              user: {
                name: 'geho',
                email: 'geho@example.com',
                password: 'password2',
                password_confirmation: 'password2'
              }
            }
      is_expected.to redirect_to('/')
    end
  end
end
