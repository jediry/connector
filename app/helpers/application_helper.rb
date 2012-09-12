module ApplicationHelper
  DAY_OF_WEEK_NAMES = [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ];

  def link_to_add_field(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_field(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def link_to_delete_field(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "delete_field(this)")
  end

  def day_of_week_names
    DAY_OF_WEEK_NAMES
  end

  def day_of_week_name(index)
    DAY_OF_WEEK_NAMES[index]
  end
end
