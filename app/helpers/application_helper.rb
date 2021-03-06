module ApplicationHelper

  def common_date(date)
    date.strftime("%B #{date.day.ordinalize}, %Y")
  end

  def common_time(time, options = {})
    return time.strftime('%l:%M %p') if options[:daily]
    return time.strftime('%a %l:%M %p') if options[:daily_with_dow]
    return time.strftime('%B %l:%M %p') if options[:weekly]
    time.strftime("%B #{time.day.ordinalize}, %Y at %l:%M %p")
  end

  def edit_button(object, name = object.class.to_s.titleize)
    link_to [:edit, object], class: "#{name.blank? ? 'panel-actions' : 'btn btn-default'} pull-right" do
      name = 'Edit '+name if name == object.class.to_s.titleize
      '%s <i class="fa fa-pencil"></i>'.html_safe % name
    end
  end

  def destroy_button(object, name = object.class.to_s.titleize)
    link_to object, method: :delete, class: "#{name.blank? ? 'panel-actions' : 'btn btn-default'} pull-right" do
      name = 'Delete '+name if name == object.class.to_s.titleize
      '%s <i class="fa fa-remove"></i>'.html_safe % name
    end
  end
end
