require 'time_distribution/smart_duration'

module TimeDistribution
  class Task
    attr_reader :subject, :time_taken, :desc

    def self.from_map(map_data)
      self.new(
        map_data['subject'].to_sym,
        map_data['duration'],
        map_data['description']
      )
    end

    # @param [#to_s] subject The subject on which the task was completed. E.g. A course or project.
    # @param [#to_s] time_taken The amount of time taken on the task (Compatible with +ChronicDuration+ parsing, or a range of times that conform to +Chronic+ parsing).
    # @param [#to_s] desc The task's description.
    def initialize(subject, time_taken, desc)
      @subject = subject
      @duration_string = time_taken
      @time_taken = SmartDuration.parse(time_taken)
      @desc = desc
    end

    def ==(other)
      (
        other.subject == @subject &&
        other.time_taken == @time_taken &&
        other.desc == @desc
      )
    end

    def to_s() "#{to_headline}: #{to_desc}" end

    def to_h
      {
        'subject' => @subject.to_s,
        'duration' => @duration_string,
        'description' => @desc
      }
    end

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
