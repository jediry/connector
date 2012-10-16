class Message < ActiveRecord::Base
  attr_accessible :content, :sort_order, :title

  validates :title, :content, :presence => true
  validates :sort_order, :presence => true, :uniqueness => true

  before_validation :ensure_sort_order

private
  # If the sort_order field is nil, sort this one at the end of the list
  def ensure_sort_order
    if self.sort_order.nil?
      max = Message.maximum(:sort_order)
      if max.nil?
        self.sort_order = 0
      else
        self.sort_order = max + 1
      end
    end
  end
end
