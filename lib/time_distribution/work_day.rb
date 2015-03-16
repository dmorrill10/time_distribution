require 'chronic'
require 'ruby-duration'

require 'time_distribution/task_list'

module TimeDistribution
  class WorkDay
    attr_reader :date, :tasks

    # @param [#to_s] date Date of this work day in +Chronic+ compatible format.
    # @param [Array<Task>] tasks List of tasks done in this work day. Defaults to an empty list.
    def initialize(date, *tasks)
      @date = Chronic.parse(date)
      @tasks = TaskList.new(*tasks)
    end

    # @param [Task] task Adds +task+ to the list of tasks completed on this work day.
    def add_task!(task)
      @tasks << task
      self
    end

    def time_worked(*subjects) @tasks.time_worked *subjects end

    def to_hours(*subjects) @tasks.to_hours *subjects end

    def to_md
      (
        @date.strftime('%b %-d, %Y') +
        "\n============================\n" +
        @tasks.to_md
      )
    end

    def to_ssv
      (
        "# #{@date.strftime('%b %-d, %Y')}\n" + (
          if block_given?
            @tasks.to_ssv { |key| yield(key) }
          else
            @tasks.to_ssv
          end
        )
      )
    end
  end
end