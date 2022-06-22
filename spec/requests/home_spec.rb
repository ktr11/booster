# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home', type: :request do
  let(:title_top) { 'booster' }
  let(:title_home) { 'ホーム | booster' }

  describe 'GET /' do
    it 'get top' do
      get '/'
      expect(response).to have_http_status(200)
      expect(response.body).to match(%r{<title>#{title_top}</title>})
      expect(response.body).to match(%r{booster})
      expect(response.body).to match(%r{ログイン})
      expect(response.body).to match(%r{新規登録})
      expect(response.body).to match(%r{ゲストログイン})
    end
  end
end
