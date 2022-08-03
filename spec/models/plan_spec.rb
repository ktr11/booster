# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan, type: :model do
  it '各項目の値が有効ならば、登録OK' do
    plan = build(:plan)
    expect(plan).to be_valid
  end
  it 'user_idが空ならば、登録NG' do
    plan = build(:plan)
    plan.user_id = nil
    expect(plan).to be_invalid
  end

  it 'start_dateが空ならば、登録NG' do
    plan = build(:plan)
    plan.start_date = nil
    expect(plan).to be_invalid
  end
  it 'start_dateが日付でなければ、登録NG' do
    plan = build(:plan)
    plan.start_date = '2022/09/31'
    expect(plan).to be_invalid
  end
  it 'start_timeが空ならば、登録NG' do
    plan = build(:plan)
    plan.start_time = nil
    expect(plan).to be_invalid
  end
  it 'start_timeが時刻でなければ、登録NG' do
    plan = build(:plan)
    plan.start_time = '22:70'
    expect(plan).to be_invalid
  end

  it 'end_dateが空ならば、登録NG' do
    plan = build(:plan)
    plan.end_date = nil
    expect(plan).to be_invalid
  end
  it 'end_dateが日付でなければ、登録NG' do
    plan = build(:plan)
    plan.end_date = '2022/09/31 13:00'
    expect(plan).to be_invalid
  end
  it 'end_timeが空ならば、登録NG' do
    plan = build(:plan)
    plan.end_time = nil
    expect(plan).to be_invalid
  end
  it 'end_timeが時刻でなければ、登録NG' do
    plan = build(:plan)
    plan.end_time = '22:70'
    expect(plan).to be_invalid
  end

  it 'start_date,timeとend_date,timeが等しいならば、登録NG' do
    plan = build(:plan)
    plan.start_date = plan.end_date
    expect(plan).to be_invalid
  end
  it 'start_date,timeがend_date,timeより後ならば、登録NG' do
    plan = build(:plan)
    plan.start_date = plan.end_date + 1.second
    expect(plan).to be_invalid
  end

  it 'all_dayがtrueならば、start_time,end_timeは空でも登録OK' do
    plan = build(:plan)
    plan.all_day = true
    plan.start_time = nil
    plan.end_time = nil
    expect(plan).to be_valid
  end

  # 実績時間のバリデーション
  it 'doneがtrueならば、実績時間は必須' do
    plan = build(:plan)
    plan.done = true
    plan.actual_time = nil
    expect(plan).to be_invalid
  end
  it '実績時間が数値でなければ、登録NG' do
    plan = build(:plan)
    plan.done = true
    plan.actual_time = 'a'
    expect(plan).to be_invalid
  end
  it '実績時間がマイナスであれば、登録NG' do
    plan = build(:plan)
    plan.done = true
    plan.actual_time = '-60'
    expect(plan).to be_invalid
  end
  it '実績時間が小数であれば、登録NG' do
    plan = build(:plan)
    plan.done = true
    plan.actual_time = '5.5'
    expect(plan).to be_invalid
  end
  it '実績時間が0であれば、登録OK' do
    plan = build(:plan)
    plan.done = true
    plan.actual_time = '0'
    expect(plan).to be_valid
  end

  it 'doneがfalseであれば、 実績時間はnil' do
    plan = create(:plan, done: true)
    plan.done = false
    plan.actual_time = '1'
    plan.save
    plan_after = Plan.find(plan.id)
    expect(plan_after.actual_time).to eq nil
  end
end
