class AddTitleTemplateToTaskTypes < ActiveRecord::Migration
  def change
    add_column :task_types, :title_template, :string
  end
end
