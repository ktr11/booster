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
  it 'start_datetimeが空ならば、登録NG' do
    plan = build(:plan)
    plan.start_datetime = nil
    expect(plan).to be_invalid
  end
  it 'start_datetimeが日付でなければ、登録NG' do
    plan = build(:plan)
    plan.start_datetime = '2022/09/31 12:00'
    expect(plan).to be_invalid
  end
  it 'end_datetimeが空ならば、登録NG' do
    plan = build(:plan)
    plan.end_datetime = nil
    expect(plan).to be_invalid
  end
  it 'end_datetimeが日付でなければ、登録NG' do
    plan = build(:plan)
    plan.end_datetime = '2022/09/31 13:00'
    expect(plan).to be_invalid
  end
  it 'start_datetimeとend_datetimeが等しいならば、登録NG' do
    plan = build(:plan)
    plan.start_datetime = plan.end_datetime
    expect(plan).to be_invalid
  end
  it 'start_datetimeがend_datetimeより後ならば、登録NG' do
    plan = build(:plan)
    plan.start_datetime = plan.end_datetime + 1.second
    expect(plan).to be_invalid
  end
end
