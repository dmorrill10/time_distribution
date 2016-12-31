require 'chronic'
require 'ruby-duration'

require 'time_distribution/task_list'
require 'time_distribution/task'

module TimeDistribution
  class WorkDay
    attr_reader :date, :tasks

    def self.from_map(map_data)
      self.new(
        map_data['date'],
        *(map_data['tasks'].map { |t| Task.from_map t })
      )
    end

    # @param [#to_s] date Date of this work day in +Chronic+ compatible format.
    # @param [Array<Task>] tasks List of tasks done in this work day. Defaults to an empty list.
    def initialize(date, *tasks)
      @date = Chronic.parse(date)
      @tasks = if tasks.length == 1 && !tasks.first.is_a?(Task)
        TaskList.new(*tasks)
      else
        TaskList.new(tasks)
      end
    end

    def ==(other) (@date == other.date && @tasks == other.tasks) end

    def to_h
      {
        'date' => @date.strftime('%B %-d, %Y'),
        'tasks' => @tasks.map { |e| e.to_h }
      }
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
