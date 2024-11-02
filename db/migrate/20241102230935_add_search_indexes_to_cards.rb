class AddSearchIndexesToCards < ActiveRecord::Migration[7.0]
  def change
    add_index :cards, :title
    add_index :cards, :description
  end
end