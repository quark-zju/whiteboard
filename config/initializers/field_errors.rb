ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  # smart add field_with_errors class, do not wrap them in a new class
  
  class_needle = ' class="'
  class_added = 'field_with_error'

  if html_tag.include? class_needle
    html_tag.sub(class_needle, "#{class_needle}#{class_added} ")
  else
    html_tag.sub('>', " class=\"#{class_added}\">")
  end.html_safe

end
