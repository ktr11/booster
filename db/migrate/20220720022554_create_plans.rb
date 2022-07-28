class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.boolean :all_day
      t.datetime :start_datetime, limit: 6
      t.datetime :end_datetime, limit: 6
      t.integer :actual_time # in minutes
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
