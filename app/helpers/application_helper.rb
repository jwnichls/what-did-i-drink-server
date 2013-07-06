module ApplicationHelper

  def print_time(date)
    timestr = date.strftime("%l:%M %P")
    datestr = ""

    if date.to_date == Time.zone.today
      datestr = "Today"
    elsif date.to_date == (Time.zone.today - 1.day)
      datestr = "Yesterday"
    elsif Time.zone.now.year == date.year
      datestr = date.strftime("%B %e")
    else
      datestr = date.strftime("%b %e, %Y")
    end

    datestr + " at " + timestr
  end
end
