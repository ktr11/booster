# frozen_string_literal: true

# 時刻チェック用Validator
class TimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    before_cast_value = record.send("#{attribute}_before_type_cast")
    Time.parse before_cast_value if value.present?
  rescue ArgumentError, TypeError
    record.errors.add(attribute, I18n.t('errors.messages.invalid'))
  end
end
