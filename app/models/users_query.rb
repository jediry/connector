class UsersQuery
  include ActiveAttr::Model

  attribute :order_by,      :type => String, :default => :name
  attribute :reverse_order, :type => Boolean, :default => false
  attribute :active,    :type => String, :default => 'yes'
  attribute :name_like, :type => String
  attribute :username_like, :type => String
  attr_accessible :order_by, :reverse_order, :active, :name_like, :username_like

  # TODO: Figure out how to merge this with 'get_sort' below
  def self.sortable_fields
    [ 'name', 'username', 'creation' ]
  end

  def find
    q = User.joins(:person).order(get_sort)
    if reverse_order?
      q = q.reverse_order
    end
    if !active.blank?
      q = q.where(:active => active == 'yes')
    end
    if !name_like.blank?
      q = q.where('people.name LIKE ?', "%#{name_like}%")
    end
    if !username_like.blank?
      q = q.where('username LIKE ?', "%#{username_like}%")
    end

    return q
  end

private
  def get_sort
    if !order_by.blank?
      return 'people.name' if order_by == 'name'
      return 'username' if order_by == 'username'
      return 'created_at' if order_by == 'creation'
    end

    # If no order_by was specified, or if it's invalid, sort by name
    'people.name'
  end
end
