# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'name、email、passwordがすべて有効ならば、登録OK' do
    user = build(:user)
    expect(user).to be_valid
  end
  it 'nameが空ならば、登録NG' do
    user = build(:user)
    user.name = ''
    expect(user).to be_invalid
  end
  it 'emailが空ならば、登録NG' do
    user = build(:user)
    user.email = ''
    expect(user).to be_invalid
  end
  it 'emailの形式が不正ならば、登録NG' do
    user = build(:user)
    user.email = '@example.com'
    expect(user).to be_invalid
    user.email = 'hoge@'
    expect(user).to be_invalid
    user.email = 'hoge@com'
    expect(user).to be_invalid
    user.email = 'hoge@example.com'
    expect(user).to be_valid
  end
  it 'emailが登録時に小文字に変換されれば、OK' do
    user = build(:user)
    user.email = 'HogE@ExamplE.COM'
    user.save
    expect(user.email).to eq 'hoge@example.com'
  end
  it 'emailが重複時は登録NG' do
    user1 = create(:user)
    expect(user1).to be_valid
    user2 = build(:user)
    user2.email = user1.email
    expect(user2).to be_invalid
  end
  it 'パスワードが空ならば、登録NG' do
    user = User.new(
      name: 'hoge',
      email: 'hoge@example.com',
      password: ''
    )
    expect(user).to be_invalid
  end
  it 'パスワード最小文字数チェック。5文字は、登録NG' do
    user1 = User.new(
      name: 'hoge1',
      email: 'hoge@example.com',
      password: 'xxxx5'
    )
    expect(user1).to be_invalid
    user2 = User.new(
      name: 'hoge2',
      email: 'hoge@example.com',
      password: 'xxxxx6'
    )
    expect(user2).to be_valid
  end
end
