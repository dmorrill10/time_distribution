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

    def to_s() "#{to_headline}: #{to_desc}" end

    def to_desc() @desc.strip end

    def to_headline
      "#{to_hours_s} hours of #{@subject}"
    end

    def to_hours
      @time_taken.total / (60 * 60).to_f
    end

    def to_hours_s
      format('%0.2f', to_hours)
    end

    def to_ssv
      format(
        "%-30s%10s",
        (
          if block_given?
            yield(@subject)
          else
            @subject
          end
        ),
        to_hours_s
      )
    end
  end
end