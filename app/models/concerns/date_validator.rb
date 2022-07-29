# frozen_string_literal: true

# 日付チェック用Validator(キャスト前の属性が渡ってくる想定)
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Date.parse value if value.present?
  rescue ArgumentError, TypeError
    record.errors.add(attribute, I18n.t('errors.messages.invalid'))
  end
end
