module ApplicationHelper
  def fix_url(str)
    if str.starts_with?('http://') || str.starts_with?('https://')
      str
    else
      "http://#{str}"
    end
  end

  def format_datetime(dt)
    dt.strftime('%m/%d/%Y at %H:%M%P %Z')
  end
end
