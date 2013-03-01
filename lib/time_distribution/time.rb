require 'chronic'

class Time
  def count_forward_to(time)
    if self > time
      (Chronic.parse('11:59:59pm') - self) + (time - Chronic.parse('12:00:00am')) + 1
    else 
      time - self
    end
  end
end