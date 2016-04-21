require_relative 'support/spec_helper'
require 'yaml'

require 'time_distribution/task'
require 'time_distribution/smart_duration'

include TimeDistribution

describe Task do
  let(:yml_string_data) do
    <<-END
subject: :time_distribution
duration: 3:38pm to 4pm
description: |
  - Comment 1
  - Comment 2
END
  end


  describe '#from_map' do
    it 'works' do
      map_data = YAML.load(yml_string_data)
      patient = Task.from_map(map_data)

      patient.subject.must_equal map_data['subject']
      patient.time_taken.must_equal SmartDuration.parse(map_data['duration'])
      patient.desc.must_equal map_data['description']
    end
  end

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
  describe 'to_s' do
    it 'works' do
      x_subject = 'subject'
      x_time_taken = '10 min'
      x_description = 'interesting description'

      patient = Task.new(x_subject, x_time_taken, x_description)

      patient.to_s.must_equal "#{format('%0.2f', (10/60.0))} hours of #{x_subject}: #{x_description}"
    end
  end
  describe 'to_hours' do
    it 'works' do
      x_subject = 'subject'
      x_time_taken = '10 min'
      x_description = 'interesting description'

      patient = Task.new(x_subject, x_time_taken, x_description)

      patient.to_hours.must_equal (10/60.0)
    end
  end
end
