class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.references :task
      t.references :user
      t.text :content

      t.timestamps
    end
    add_index :notes, :task_id
  end
end
