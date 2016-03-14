require_relative 'support/spec_helper'

require 'time_distribution/smart_duration'

def hours_in_seconds(hours)
  return hours * 60 * 60
end

def minutes_in_seconds(minutes)
  return minutes * 60
end

include TimeDistribution
describe SmartDuration do
  describe '::parse' do
    describe 'can interpret a range of times' do
      it 'written with "to"' do
        SmartDuration.parse('10am to 11:30am').total.must_equal hours_in_seconds(1.5)
      end
      it 'written with "-"' do
        SmartDuration.parse('10am-11:11am').total.must_equal hours_in_seconds(1) + minutes_in_seconds(11)
      end
    end
    it 'can interpret an explicit range' do
      SmartDuration.parse('1 hour 30 minutes').total.must_equal hours_in_seconds(1.5)
    end
  end
end