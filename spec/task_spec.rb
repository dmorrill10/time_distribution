require_relative 'support/spec_helper'

require 'time_distribution/task'
require 'time_distribution/smart_duration'

include TimeDistribution

describe Task do
  describe '#new' do
    it 'works for three arguments' do
      x_subject = 'subject'
      x_time_taken = '10 min'
      x_description = 'interesting description'

      patient = Task.new(x_subject, x_time_taken, x_description)

      patient.subject.must_equal x_subject
      patient.time_taken.must_equal SmartDuration.parse(x_time_taken)
      patient.desc.must_equal x_description
    end
  end
end
