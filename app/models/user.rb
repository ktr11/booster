# frozen_string_literal: true

# usersテーブルに関するmodelファイル
class User < ApplicationRecord
  before_save :downcase_email
  has_many :plans, dependent: :destroy
  # name のvalidation
  validates(:name, presence: true)
  # email の validation
  VALID_EMAIL_REGEX = %r{\A[a-z\d]+[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z}i
  validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false })
  # passwordのvalidation セキュアなパスワード
  has_secure_password
  validates(:password, presence: true, length: { minimum: 6 }, allow_nil: true)

  private

  # メールアドレスを小文字に変更
  def downcase_email
    email.downcase!
  end
end
