class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.string :status
      t.string :card_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
