require 'chronic'
require 'ruby-duration'

module TimeDistribution
  module TimeRefinement
    refine Time do
      def count_forward_to(time)
        (time - self) + if self > time
          24 * 60 * 60
        else
          0
        end
      end
    end
  end
end
