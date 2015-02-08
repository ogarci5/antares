module DashboardHelper
  def welcome_text
    time = Time.now
    case time.hour
      when 4..11
        'Good Morning'
      when 12..6
        'Good Afternoon'
      else
        'Good Evening'
    end
  end
end
