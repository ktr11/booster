# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  describe 'log_inメソッドのテスト' do
    it 'log_inメソッドに渡したuserとセッションのidが等しければOK' do
      user = create(:user)
      log_in(user)
      expect(session[:user_id]).to eq user.id
      match(logged_in?)
    end
  end
  describe 'current_userメソッドのテスト' do
    it 'current_userメソッドの結果とログインユーザーが等しければOK' do
      user = create(:user)
      user2 = create(:user)
      log_in(user)
      expect(current_user).to eq user
      expect(current_user).not_to eq user2
      match(current_user?(user))
      match(current_user?(user2))
    end
  end
end
