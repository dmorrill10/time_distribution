require 'chronic'
require 'ruby-duration'

module TimeDistribution
  class WorkDay
    attr_reader :date, :tasks

    # @param [#to_s] date Date of this work day in +Chronic+ compatible format.
    # @param [Array<Task>] tasks List of tasks done in this work day. Defaults to an empty list.
    def initialize(date, tasks=[])
      @date = Chronic.parse(date)
      @tasks = tasks
    end

    # @param [Task] task Adds +task+ to the list of tasks completed on this work day.
    def add_task!(task)
      @tasks << task

      self
    end

    def time_worked(*subjects)
      subjects.flatten!
      times = {}
      unless subjects.empty? || subjects.kind_of?(Set)
        subjects = Set.new(subjects) # To take advantage of Set's faster include? check
      end

      times_to_return = @tasks.inject({}) do |times, t|
        t_subject = t.subject
        next times unless subjects.empty? || subjects.include?(t_subject)

        times[t_subject] = Duration.new(0) unless times[t_subject]
        times[t_subject] += t.time_taken
        times
      end

      if times_to_return.length == 1
        times_to_return.values.first
      else
        times_to_return
      end
    end
  end
end