require_relative 'support/spec_helper'

require 'time_distribution/smart_duration'

include TimeDistribution
describe SmartDuration do
  describe '::parse' do
    describe 'can interpret a range of times' do
      it 'written with "to"' do
        SmartDuration.parse('10am to 11:30am').total.must_equal 1.5.hours
      end
      it 'written with "-"' do
        SmartDuration.parse('10am-11:11am').total.must_equal 1.hours + 11.minutes
      end
    end
    it 'can interpret an explicit range' do
      SmartDuration.parse('1 hour 30 minutes').total.must_equal 1.5.hours
    end
  end
end