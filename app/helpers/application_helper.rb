module ApplicationHelper
  def fix_url(str)
    if str.starts_with?('http://') || str.starts_with?('https://')
      str
    else
      "http://#{str}"
    end
  end

  def format_datetime(dt)
    if logged_in? && current_user.time_zone.present?
      dt = dt.in_time_zone(current_user.time_zone)
    end
    dt.strftime('%m/%d/%Y at %H:%M%P %Z')
  end
end
