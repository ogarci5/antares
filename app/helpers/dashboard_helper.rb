module DashboardHelper
  def welcome_text
    time = Time.zone.now
    case time.hour
      when 4..11 then return 'Good Morning'
      when 12..18 then return 'Good Afternoon'
      else return 'Good Evening'
    end
  end
end
