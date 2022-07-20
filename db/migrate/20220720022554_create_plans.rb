class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.boolean :all_day
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer :actual_time # in minutes

      t.timestamps
    end
  end
end
