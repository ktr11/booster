# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  let(:plan_params) do
    {
      title: 'test1',
      content: 'hogehoge',
      all_day: 'false',
      start_date: '2020-01-01',
      start_time: '09:00',
      end_date: '2020-01-01',
      end_time: '18:00',
      done: true
    }
  end
  # 予定登録画面初期表示
  describe 'GET /plans/new' do
    it '200になり想定どおりの文字列が含まれる' do
      get '/plans/new'
      expect(response).to have_http_status(200)
      expect(response.body).to include('タイトル')
      expect(response.body).to include('内容')
      expect(response.body).to include('終日')
      expect(response.body).to include('開始日時')
      expect(response.body).to include('終了日時')
    end
  end
  # 予定登録処理
  describe 'POST /plans' do
    it '予定を登録できる' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params
      }
      plan = Plan.find_by(title: 'test1')
      expect(response).to have_http_status(302)
      is_expected.to redirect_to("/plans/#{plan.id}")
      get "/plans/#{plan.id}"
      expect(response.body).to include('予定を登録しました。')
      expect(plan_count + 1).to eq Plan.count
      plan = Plan.find_by(title: 'test1')
      expect(plan).to_not eq nil
      expect(plan.user).to eq user
      expect(plan.title).to eq 'test1'
      expect(plan.content).to eq 'hogehoge'
      expect(plan.start_date).to eq Date.new(2020, 1, 1)
      expect(plan.start_time).to eq Time.new(2000, 1, 1, 9, 0, 0)
      expect(plan.end_date).to eq Date.new(2020, 1, 1)
      expect(plan.end_time).to eq Time.new(2000, 1, 1, 18, 0, 0)
      expect(plan.all_day).to eq false
      expect(plan.done).to eq false
    end
    it '予定を登録できる(終日)' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(all_day: true, start_time: '', end_time: '')
      }
      plan = Plan.find_by(title: 'test1')
      expect(response).to have_http_status(302)
      is_expected.to redirect_to("/plans/#{plan.id}")
      get "/plans/#{plan.id}"
      expect(response.body).to include('予定を登録しました。')
      expect(plan_count + 1).to eq Plan.count
      plan = Plan.find_by(title: 'test1')
      expect(plan).to_not eq nil
      expect(plan.start_time).to eq nil
      expect(plan.end_time).to eq nil
      expect(plan.all_day).to eq true
    end

    it '予定を登録できる。終日の場合は、timeが入っていてもnilで登録' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(all_day: true)
      }
      plan = Plan.find_by(title: 'test1')
      expect(response).to have_http_status(302)
      is_expected.to redirect_to("/plans/#{plan.id}")
      get "/plans/#{plan.id}"
      expect(response.body).to include('予定を登録しました。')
      expect(plan_count + 1).to eq Plan.count
      plan = Plan.find_by(title: 'test1')
      expect(plan.start_time).to eq nil
      expect(plan.end_time).to eq nil
      expect(plan.all_day).to eq true
    end
    it '予定を登録できない、start_dateが空' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(start_date: '')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('開始日を入力してください')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、start_dateが不正' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(start_date: '2022/09/31')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('開始日は不正な値です')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、start_timeが空' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(start_time: '')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('開始時刻を入力してください')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、start_timeが不正' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(start_time: '25:50')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('開始時刻は不正な値です')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、end_dateが空' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(end_date: '')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('終了日を入力してください')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、end_dateが不正' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(end_date: '2022/09/31')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('終了日は不正な値です')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、end_timeが空' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(end_time: '')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('終了時刻を入力してください')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、end_timeが不正' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(end_time: '25:50')
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('終了時刻は不正な値です')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、start_date,timeとend_date,timeが同じ' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(
          start_date: '2022/01/01', start_time: '20:00',
          end_date: '2022/01/01', end_time: '20:00'
        )
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('終了日時は開始日時より後に設定してください')
      expect(plan_count).to eq Plan.count
    end
    it '予定を登録できない、start_date,time > end_date,time' do
      plan_count = Plan.count
      user = create(:user)
      login_as(user)
      post '/plans', params: {
        plan: plan_params.merge(
          start_date: '2022/01/01', start_time: '20:01',
          end_date: '2022/01/01', end_time: '20:00'
        )
      }
      expect(response).to have_http_status(200)
      expect(response.body).to include('終了日時は開始日時より後に設定してください')
      expect(plan_count).to eq Plan.count
    end
    # 予定更新
    describe 'PATCH /plans/plan.id' do
      it '予定を更新できる' do
        user = create(:user)
        login_as(user)
        plan = create(:plan, user: user)
        plan_count = Plan.count
        patch "/plans/#{plan.id}", params: {
          plan: plan_params.merge(
            title: 'test2', content: 'hogehoge2',
            start_date: '2022/01/02', start_time: '20:00',
            end_date: '2022/01/02', end_time: '21:00'
          )
        }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to("/plans/#{plan.id}")
        expect(plan_count).to eq Plan.count
        plan = Plan.find(plan.id)
        expect(plan.user).to eq user
        expect(plan.title).to eq 'test2'
        expect(plan.content).to eq 'hogehoge2'
        expect(plan.start_date).to eq Date.new(2022, 1, 2)
        expect(plan.start_time).to eq Time.new(2000, 1, 1, 20, 0, 0)
        expect(plan.end_date).to eq Date.new(2022, 1, 2)
        expect(plan.end_time).to eq Time.new(2000, 1, 1, 21, 0, 0)
        expect(plan.all_day).to eq false
        expect(plan.done).to eq false
      end
      it '予定を更新できる(終日でない→終日)' do
        user = create(:user)
        login_as(user)
        plan = create(:plan, user: user)
        plan_count = Plan.count
        patch "/plans/#{plan.id}", params: {
          plan: plan_params.merge(
            all_day: true
          )
        }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to("/plans/#{plan.id}")
        expect(plan_count).to eq Plan.count
        plan = Plan.find(plan.id)
        expect(plan.user).to eq user
        expect(plan.start_time).to eq nil
        expect(plan.end_time).to eq nil
        expect(plan.all_day).to eq true
      end
    end
    # 予定詳細
    describe 'GET /plans/plan.id' do
      it '予定詳細を表示できる' do
        user = create(:user)
        login_as(user)
        plan = create(:plan, user: user)
        get "/plans/#{plan.id}"
        expect(response).to have_http_status(200)
        expect(response.body).to include(plan.title)
        expect(response.body).to include(plan.content)
        expect(response.body).to include(plan.start_date.strftime('%Y/%m/%d'))
        expect(response.body).to include(plan.start_time.strftime('%H:%M'))
        expect(response.body).to include(plan.end_date.strftime('%Y/%m/%d'))
        expect(response.body).to include(plan.end_time.strftime('%H:%M'))
      end
      it '予定詳細を表示できる(終日)' do
        user = create(:user)
        login_as(user)
        plan = create(:plan, user: user, all_day: true)
        get "/plans/#{plan.id}"
        expect(response).to have_http_status(200)
        expect(response.body).to include('(終日)')
      end
    end
    # 予定編集
    describe 'GET /plans/plan.id/edit' do
      it '予定編集を表示できる' do
        user = create(:user)
        login_as(user)
        plan = create(:plan, user: user)
        get "/plans/#{plan.id}/edit"
        expect(response).to have_http_status(200)
        expect(response.body).to include(plan.title)
        expect(response.body).to include(plan.content)
        expect(response.body).to include(plan.start_date.strftime('%Y-%m-%d'))
        expect(response.body).to include(plan.start_time.strftime('%H:%M'))
        expect(response.body).to include(plan.end_date.strftime('%Y-%m-%d'))
        expect(response.body).to include(plan.end_time.strftime('%H:%M'))
      end
    end
    # 予定削除
    describe 'DELETE /plans/plan.id' do
      it '予定削除できる' do
        user = create(:user)
        login_as(user)
        plan = create(:plan, user: user)
        plan_count = Plan.count
        delete "/plans/#{plan.id}"
        expect(response).to have_http_status(302)
        expect(response).to redirect_to('/')
        expect(plan_count - 1).to eq Plan.count
      end
    end
  end
end