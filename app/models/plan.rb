# frozen_string_literal: true

# plansテーブルに関するmodelファイル
class Plan < ApplicationRecord
  belongs_to :user
  # start_datetimeのvalidation
  validates :start_datetime, presence: true, date: true
  # end_datetimeのvalidation
  validates :end_datetime, presence: true, date: true
  # start_datetimeとend_datetimeの前後関係をvalidation
  validate :start_end_datetime_relation

  private

  def start_end_datetime_relation
    errors.add(:end_datetime, 'は開始日時より後に設定してください') if start_datetime && end_datetime && (start_datetime >= end_datetime)
  end
end
