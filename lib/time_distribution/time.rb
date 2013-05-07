require 'chronic'

module TimeDistribution
  module TimeRefinement
    refine Time do
      def count_forward_to(time)
        if self > time
          (Chronic.parse('11:59:59pm') - self) + (time - Chronic.parse('12:00:00am')) + 1
        else
          time - self
        end
      end
    end
  end
end
