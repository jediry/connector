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

  def link_to_add_field(name, f, association, html_options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_field(this, \"#{association}\", \"#{escape_javascript(fields)}\")", html_options)
  end

  def link_to_delete_field(name, f, hide_selector, html_options = {})
    f.hidden_field(:_destroy) + link_to_function(name, "delete_field(this, \"#{escape_javascript(hide_selector)}\")", html_options)
  end

  def validated_telephone_field(name, f)
    f.telephone_field name, :value => format_telephone(f.object.read_attribute(name)), :onchange => "format_telephone_field(this)"
  end

  def validated_email_field(name, f)
    f.email_field name
  end

  def task_type_select(name, f, options = {})
    f.collection_select name, TaskType.all, :id, :description, options
  end

  def active_user_select(name, f, options = {})
    f.collection_select name, User.where(:active => true), :id, :name, options
  end

  def active_group_select(name, f, options = {})
    f.collection_select name, Group.all, :id, :name, options
  end

  # Formats a 10-digit phone number like '(911) 123-4567'. Any additional digits are treated as the extension.
  def format_telephone(number)
    if (number.blank?)
      return ''
    end

    area = number[0, 3].rjust(3)
    prefix = number[3, 3].rjust(3)
    suffix = number[6, 4].rjust(4)
    ext = number[10..-1]

    formatted = "(#{area}) #{prefix}-#{suffix}"
    if !ext.blank?
      formatted += " x#{ext}"
    end

    return formatted
  end

  # Formats a body of plain text for display as HTML. Newlines are turned into <br /> tags, and URLs are turned into
  # hyperlinks.
  def format_plain_text(text)
    # First, escape any HTML that might be in there. Cross-site scripting baaaaad.
    text = h( text )

    # Now replace newlines
    text = text.gsub /$/, '<br />'

    # Now replace URLs
    text = text.gsub /\b(http:\/\/[A-Za-z0-9_.%\/-]+)/, '<a href="\1">\1</a>'
    text = text.gsub /(?<!http:\/\/)\b(www\.[A-Za-z0-9_.%\/-]+)/, '<a href="http://\1">\1</a>'
    text = text.gsub /([0-9a-z][0-9a-z.-]+[0-9a-z]@[0-9a-z][0-9a-z.-]+[0-9a-z])/xi, '<a href="mailto:\1">\1</a>'

    raw( text )
  end

  # Friendly title for this task
  def task_title(task, options = {})
    p = task.person
    if options[:link_to_person]
      raw( task.task_type.title_template.sub /<name>/, link_to(p.name, p) )
    else
      raw( task.task_type.title_template.sub /<name>/, p.name )
    end
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
