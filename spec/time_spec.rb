require_relative 'support/spec_helper'
require 'time_distribution/time'
require 'chronic'

include TimeDistribution
using TimeRefinement

def hours_in_seconds(hours)
  return hours * 60 * 60
end

DATE_TO_AVOID_DSL_PROBLEMS = '1/01/0001'

describe Time do
  describe '#count_forward_to' do
    it 'counts duration properly when both times are in AM' do
      Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 10am").count_forward_to(Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 11:30am")).must_equal hours_in_seconds(1.5)
    end
    it 'counts duration properly when both times are in PM' do
      Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 10pm").count_forward_to(Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 11:30pm")).must_equal hours_in_seconds(1.5)
    end
    it 'counts duration properly when it crosses from AM to PM' do
      Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 11am").count_forward_to(Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 12:30pm")).must_equal hours_in_seconds(1.5)
    end
    it 'counts duration properly when it crosses from PM to AM' do
      Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 11pm").count_forward_to(Chronic.parse("#{DATE_TO_AVOID_DSL_PROBLEMS} 12:30am")).must_equal hours_in_seconds(1.5)
    end
  end
end