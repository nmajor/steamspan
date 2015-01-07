module ApplicationHelper
  def minutes_to_words mm
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    "<span class=\"day-words\">#{dd} days,</span class=\"hour-words\"><span>#{hh} hours,</span><span class=\"minute-words\">#{mm} minutes</span>".html_safe
  end

  def minutes_to_short_words mm, never_blank=nil
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    str = ''
    str += "#{dd}d" if dd > 0
    str += "#{hh}h" if hh > 0
    str += "#{mm}m" if mm > 0

    str = "0" if str == '' && never_blank
    str
  end

  def minutes_to_hours mm
    mm / 60
  end
end
