class GroupsQuery
  include ActiveAttr::Model

  attribute :order_by,      :type => String, :default => :name
  attribute :reverse_order, :type => Boolean, :default => false
  attribute :active,    :type => String, :default => 'yes'
  attribute :region,    :type => String
  attribute :name_like, :type => String
  attr_accessible :order_by, :reverse_order, :active, :region, :name_like

  # TODO: Figure out how to merge this with 'get_sort' below
  def self.sortable_fields
    [ 'name', 'creation', 'region' ]
  end

  def each(group_type, &block)
    q = Group.where(:group_type_id => group_type.id)
    q = q.order(get_sort)
    if reverse_order?
      q = q.reverse_order
    end
    if !active.blank?
      q = q.where(:active => active == 'yes')
    end
    if !region.blank?
      q = q.where(:region_id => region.to_i)
    end
    if !name_like.blank?
      q = q.where('name LIKE ?', "%#{name_like}%")
    end

    q.each { |group| yield group }
  end

private
  def get_sort
    if !order_by.blank?
      return 'name' if order_by == 'name'
      return 'created_at' if order_by == 'creation'
      # TODO: make this sort by region name, not ID
      return 'region_id' if order_by == 'region'
    end

    # If no order_by was specified, or if it's invalid, sort by name
    'name'
  end
end
