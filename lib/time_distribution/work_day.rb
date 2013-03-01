require 'chronic'
require 'ruby-duration'

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

  def time_worked
    times = {}
    @tasks.inject({}) do |times, t|
      times[t.subject] = Duration.new(0) unless times[t.subject]
      times[t.subject] += t.time_taken
      times
    end
  end
end