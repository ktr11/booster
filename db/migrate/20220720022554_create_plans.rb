class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.boolean :all_day
      t.date :start_date
      t.time :start_time
      t.date :end_date
      t.time :end_time
      t.integer :actual_time # in minutes
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
