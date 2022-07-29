# frozen_string_literal: true

# plansテーブルに関するmodelファイル
class Plan < ApplicationRecord
  belongs_to :user
  before_save :all_day_time_nil
  # start_dateのvalidation
  validates :start_date_before_type_cast, presence: true, date: true
  # end_dateのvalidation
  validates :end_date_before_type_cast, presence: true, date: true
  # 終日でない時timeは必須
  with_options if: :not_all_day? do
    validates :start_time_before_type_cast, presence: true, time: true
    validates :end_time_before_type_cast, presence: true, time: true
  end
  # start_dateとend_dateの前後関係をvalidation
  validate :start_end_relation

  private

  # start_dateとend_dateの前後関係をvalidation
  def start_end_relation
    return unless start_date && start_time && end_date && end_time

    start_datetime = DateTime.new(start_date.year, start_date.month, start_date.day,
                                  start_time.hour, start_time.min, start_time.sec)
    end_datetime = DateTime.new(end_date.year, end_date.month, end_date.day,
                                end_time.hour, end_time.min, end_time.sec)
    errors.add(:end_date, '終了日時は開始日時より後に設定してください') if start_datetime >= end_datetime
  end

  # 終日でないか判定
  def not_all_day?
    !all_day
  end

  # 終日の時は時刻をnilにする
  def all_day_time_nil
    self.start_time = nil if all_day
    self.end_time = nil if all_day
  end
end
