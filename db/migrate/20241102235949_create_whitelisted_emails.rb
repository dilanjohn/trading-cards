class CreateWhitelistedEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :whitelisted_emails do |t|
      t.string :email, null: false
      t.timestamps
    end
    
    add_index :whitelisted_emails, :email, unique: true
  end
end