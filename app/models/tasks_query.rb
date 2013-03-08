class TasksQuery
  include ActiveAttr::Model

  attribute :order_by,      :type => String, :default => 'creation'
  attribute :reverse_order, :type => Boolean, :default => true
  attribute :finished,      :type => String, :default => 'no'
  attribute :overdue_days,  :type => String
  attribute :user_name_like, :type => String
  attribute :person_name_like, :type => String
  attr_accessible :order_by, :reverse_order, :finished, :overdue_days, :user_name_like, :person_name_like

  # TODO: Figure out how to merge this with 'get_sort' below
  def self.sortable_fields
    [ 'creation' ]
#    [ 'user name', 'person name', 'creation' ]
  end

  def find(task_type)
    q = Task.where(:task_type_id => task_type.id)
    q = q.order(get_sort)
    if reverse_order?
      q = q.reverse_order
    end
    if !finished.blank?
      q = q.joins('INNER JOIN task_statuses ON task_statuses.id = task_status_id')
      q = q.where('task_statuses.finish' => finished == 'yes')
    end
    if !overdue_days.blank?
      q = q.where('attempt_next_contact_by IS NOT NULL')
      q = q.where('attempt_next_contact_by < ?', Time::current.ago(overdue_days.to_i * 60 * 60 * 24))
    end
    if !user_name_like.blank?
      q = q.joins('INNER JOIN people users ON users.id = user_id')
      q = q.where('users.name LIKE ?', "%#{user_name_like}%")
    end
    if !person_name_like.blank?
      q = q.joins('INNER JOIN people ON people.id = person_id')
      q = q.where('people.name LIKE ?', "%#{person_name_like}%")
    end

    return q
  end

private
  def get_sort
    if !order_by.blank?
#      return 'users.name' if order_by == 'user name'
#      return 'people.name' if order_by == 'person name'
      return 'created_at' if order_by == 'creation'
    end

    # If no order_by was specified, or if it's invalid, sort by creation date
    'created_at'
  end
end
