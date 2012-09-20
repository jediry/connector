module ApplicationHelper
  DAY_OF_WEEK_NAMES = %w( Sunday Monday Tuesday Wednesday Thursday Friday Saturday )
  DAY_OF_WEEK_TO_ORDINAL = {
    'Sunday'    => 0,
    'Monday'    => 1,
    'Tuesday'   => 2,
    'Wednesday' => 3,
    'Thursday'  => 4,
    'Friday'    => 5,
    'Saturday'  => 6
  }
  STATE_ABBREVIATIONS = %w( AL AK AZ AS CA CO CN DE FL GA HI ID IL IN IA KS KY LA ME MA MS MI MN MS MO MT NB NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY )

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

  def link_to_select_form(name, association)
    html = '<div>' +
             '<select name="hi">' +
               '<option value="1">Hello</option>' +
               '<option value="2">Ciao</option>' +
             '</select>' +
           '</div>'
    link_to_function(name, "add_field(this, \"#{association}\", \"#{escape_javascript(html)}\")")
  end

  def validated_telephone_field(name, f)
    f.telephone_field name, :value => format_telephone(f.object.read_attribute(name)), :onchange => "format_telephone_field(this)"
  end

  def validated_email_field(name, f)
    f.email_field name
  end

  def format_telephone(number)
    if (number.blank?)
      return ''
    end

    area = number[0, 3].rjust(3)
    prefix = number[3, 3].rjust(3)
    suffix = number[6, 4].rjust(4)
    ext = number[10]

    formatted = "(#{area}) #{prefix}-#{suffix}"
    if !ext.blank?
      formatted += " x#{ext}"
    end

    return formatted
  end

  def state_abbreviations
    STATE_ABBREVIATIONS
  end

  def day_of_week_names
    DAY_OF_WEEK_TO_ORDINAL
  end

  def day_of_week_name(index)
    DAY_OF_WEEK_NAMES[index]
  end
end
