class PeopleQuery
  include ActiveAttr::Model

  attribute :order_by,      :type => String, :default => :name
  attribute :reverse_order, :type => Boolean, :default => false
  attribute :active,    :type => String, :default => 'yes'
  attribute :member,    :type => String, :default => nil
  attribute :name_like, :type => String
  attr_accessible :order_by, :reverse_order, :active, :member, :name_like

  # TODO: Figure out how to merge this with 'get_sort' below
  def self.sortable_fields
    [ 'name', 'creation' ]
  end

  def find
    q = Person.order(get_sort)
    if reverse_order?
      q = q.reverse_order
    end
    if !active.blank?
      q = q.where(:active => active == 'yes')
    end
    if !member.blank?
      q = q.where(:member => member == 'yes')
    end
    if !name_like.blank?
      q = q.where('name LIKE ?', "%#{name_like}%")
    end

    return q
  end

private
  def get_sort
    if !order_by.blank?
      return 'name' if order_by == 'name'
      return 'created_at' if order_by == 'creation'
    end

    # If no order_by was specified, or if it's invalid, sort by name
    'name'
  end
end
