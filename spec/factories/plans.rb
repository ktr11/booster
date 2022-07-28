# frozen_string_literal: true

# Planテスト用のテストデータ作成ファイル
FactoryBot.define do
  now = Time.now
  now_hour = Time.local(now.year, now.mon, now.day, now.hour, 0, 0)
  factory :plan, class: Plan do
    user_id { create(:user).id }
    title { 'hoge' }
    content { 'hogehoge' }
    all_day { false }
    start_date { now_hour.strftime('%Y/%m/%d') }
    start_time { now_hour.strftime('%H:%M:%S') }
    end_date { (now_hour + 2.hour).strftime('%Y/%m/%d') }
    end_time { (now_hour + 2.hour).strftime('%H:%M:%S') }
    actual_time { 0 }
  end
end
