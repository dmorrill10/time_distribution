require_relative 'support/spec_helper'
require 'time_distribution/time'
require 'chronic'

include TimeDistribution
using TimeRefinement

describe Time do
  describe '#count_forward_to' do
    it 'counts duration properly when both times are in AM' do
      Chronic.parse('10am').count_forward_to(Chronic.parse('11:30am')).must_equal 1.5.hours
    end
    it 'counts duration properly when both times are in PM' do
      Chronic.parse('10pm').count_forward_to(Chronic.parse('11:30pm')).must_equal 1.5.hours
    end
    it 'counts duration properly when it crosses from AM to PM' do
      Chronic.parse('11am').count_forward_to(Chronic.parse('12:30pm')).must_equal 1.5.hours
    end
    it 'counts duration properly when it crosses from PM to AM' do
      Chronic.parse('11pm').count_forward_to(Chronic.parse('12:30am')).must_equal 1.5.hours
    end
  end
end