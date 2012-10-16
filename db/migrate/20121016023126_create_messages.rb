class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.text :content
      t.integer :sort_order

      t.timestamps
    end
  end
end
