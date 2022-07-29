# frozen_string_literal: true

# 時刻チェック用Validator(キャスト前の属性が渡ってくる想定)
class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Time.parse value if value.present?
  rescue ArgumentError, TypeError
    record.errors.add(attribute, I18n.t('errors.messages.invalid'))
  end
end
