class CreateWants < ActiveRecord::Migration[7.0]
  def change
    create_table :wants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
