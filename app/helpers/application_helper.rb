module ApplicationHelper

  def readable_date(date)
    return "[unknown]" unless date
    # return content_tag(:span, "#{time_ago_in_words(date)} ago", class: 'date', title: date.to_s)
    # https://apidock.com/ruby/DateTime/strftime
    return content_tag(:span, date.strftime("%b %d, %Y"), class: 'date', title: date.to_s)
  end

end
