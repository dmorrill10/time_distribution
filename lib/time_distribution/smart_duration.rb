require 'chronic'
require 'chronic_duration'
require 'ruby-duration'

require 'time_distribution/time'

using TimeDistribution::TimeRefinement
module TimeDistribution
  module SmartDuration
    def self.parse(time_period)
      # If the time period has is something like 1:00pm to 1:30pm or 1-2, interpret it as a range
      time_of_day_pattern = '\d+:?\d*[ap]?m?'
      date_to_avoid_dsl_problems = '1/01/0001'

      Duration.new(
        if time_period.to_s.downcase.match(
          /(#{time_of_day_pattern})\s*(to|-)\s*(#{time_of_day_pattern})/
        )
          Chronic.parse("#{date_to_avoid_dsl_problems} #{$1}").count_forward_to(
            Chronic.parse("#{date_to_avoid_dsl_problems} #{$3}")
          )
        else
          ChronicDuration.parse(time_period)
        end
      )
    end
  end
end