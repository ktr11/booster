# frozen_string_literal: true

# Plansに関するヘルパー
module PlansHelper
  # title:nilの時に表示する文字列を返す
  def nil_title_convert(title)
    title.present? ? title : '(タイトルなし)'
  end

  # 時刻を加工して返す
  def time_format(time)
    if time.nil?
      ''
    elsif time.instance_of?(ActiveSupport::TimeWithZone)
      time.strftime('%H:%M')
    else
      begin
        Time.parse time if time.present?
      rescue ArgumentError, TypeError
        ''
      end
    end
  end
end
