require 'time_distribution/smart_duration'

module TimeDistribution
  class Task
    attr_reader :subject, :time_taken, :desc

    # @param [#to_s] subject The subject on which the task was completed. E.g. A course or project.
    # @param [#to_s] time_taken The amount of time taken on the task (Compatible with +ChronicDuration+ parsing, or a range of times that conform to +Chronic+ parsing).
    # @param [#to_s] desc The task's description.
    def initialize(subject, time_taken, desc)
      @subject = subject
      @time_taken = SmartDuration.parse(time_taken)
      @desc = desc
    end
  end
end