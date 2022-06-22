require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:title_top) { 'booster' }

  describe "GET /login/" do
    it 'get login' do
      get '/login/'
      expect(response).to have_http_status(200)
      expect(response.body).to match(%r{<title>#{title_top}</title>})
      expect(response.body).to match(%r{booster})
      expect(response.body).to match(%r{メールアドレス})
      expect(response.body).to match(%r{パスワード})
    end
  end
end
