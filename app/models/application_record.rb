# frozen_string_literal: true

# 各モデルはApplicationRecordを継承する.
# 各モデルで共通的に行いたい処理をApplicationRecordに定義する.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
