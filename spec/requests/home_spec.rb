# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home', type: :request do
  let(:title_top) { 'booster' }
  let!(:user) { create(:user, email: 'hoge@example.com', password: 'password1') }

  describe 'GET /' do
    it 'get top 未ログインの場合' do
      get '/'
      expect(response).to have_http_status(200)
      expect(response.body).to include("<title>#{title_top}</title>")
      expect(response.body).to include('booster')
      expect(response.body).to include('ログイン</a>')
      expect(response.body).to include('新規登録</a>')
      expect(response.body).to include('ゲストログイン</a>')
      expect(response.body).to_not include('プロフィール</a>')
    end
    it 'get top ログイン済みの場合' do
      login_as(user)
      plan = create(:plan, user: user)
      get '/'
      expect(response).to have_http_status(200)
      expect(response.body).to include("<title>#{title_top}</title>")
      expect(response.body).to include('booster')
      expect(response.body).to_not include('ログイン</a>')
      expect(response.body).to_not include('新規登録</a>')
      expect(response.body).to_not include('ゲストログイン</a>')
      expect(response.body).to include('プロフィール</a>')
      expect(response.body).to include('予定')
      expect(response.body).to include(plan.title)
      expect(response.body).to include(plan.start_date.strftime('%Y/%m/%d'))
      expect(response.body).to include(plan.start_time.strftime('%H:%M'))
      expect(response.body).to include(plan.end_date.strftime('%Y/%m/%d'))
      expect(response.body).to include(plan.end_time.strftime('%H:%M'))
    end
  end
end
