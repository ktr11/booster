class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :photo_id
      t.string :activation_digest
      t.boolean :activated
      t.datetime :activated_at
      t.string :remember_digest
      t.string :reset_digest
      t.string :reset_sent_at

      t.timestamps
    end
  end
end
