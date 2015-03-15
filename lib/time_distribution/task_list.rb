require 'chronic'
require 'ruby-duration'

module TimeDistribution
  class TaskList < Array
    attr_reader :date, :tasks

    def time_worked(*subjects)
      inject({}) do |times, t|
        t_subject = t.subject
        if subjects.empty? || subjects.include?(t_subject)
          if times[t_subject]
            times[t_subject] += t.time_taken
          else
            times[t_subject] = Duration.new(t.time_taken)
          end
        end
        times
      end
    end

    def to_hours(*subjects)
      inject(0) do |hours, task|
        if subjects.empty? || subjects.include?(task.subject)
          hours += task.to_hours
        end
        hours
      end
    end

    def to_md
      inject('') do |task_string, t|
        task_string += "- #{t.to_s}\n"
      end
    end

    def to_ssv
      inject('') do |task_string, t|
        task_string += "#{t.to_ssv}\n"
      end
    end
  end
end