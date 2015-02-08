module ApplicationHelper
  def common_date(date)
    date.strftime("%B #{date.day.ordinalize}, %Y")
  end
end
