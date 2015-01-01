module ApplicationHelper
  def minutes_to_words mm
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    "<span class=\"day-words\">#{dd} days</span class=\"hour-words\"><span>#{hh} Hours</span><span class=\"minute-words\">#{mm} Minutes</span>".html_safe
  end
end
