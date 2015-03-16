require 'time'

require_relative 'smart_duration'
require_relative 'task'
require_relative 'work_day'

module TimeDistribution
  class WorkDayCollection < Array
    # @returns [Hash<symbol,Integer>] Hash from calendar month to the
    # => number of official work days in that month. Initialized to zero.
    attr_reader :official_work_days

    MONTHS = [:january, :february, :march, :april, :may, :june, :july, :august, :september, :october, :november, :december]

    private
    def provide_methods_for_setting_work_days_in_months
      MONTHS.each do |m|
        self.class().send(:define_method, "set_official_work_days_in_#{m.to_s}!") do |num_days|
          @official_work_days[m] = num_days
        end
      end
    end

    public

    def initialize(*days, official_work_days: {})
      super(days)
      provide_methods_for_setting_work_days_in_months
      @official_work_days = official_work_days.dup
      MONTHS.each do |m|
        @official_work_days[m] ||= 0
      end
    end

    def time_worked
      inject({}) do |hash, d|
        t = d.time_worked
        if t.respond_to?(:each_key)
          t.each_key do |key|
            hash[key] = Duration.new(0) unless hash[key]
            hash[key] += t[key]
          end
        else
          d_subject = d.tasks.first.subject
          hash[d_subject] = Duration.new(0) unless hash[d_subject]
          hash[d_subject] += t
        end
        hash
      end
    end

    def avg_hours_per_official_work_day(*subjects)
      hours(*subjects) / @official_work_days.values.inject(:+).to_f
    end

    def avg_hours_per_day_worked(*subjects)
      hours(*subjects) / length.to_f
    end

    def hours(*subjects)
      inject(0) { |sum, d| sum += d.to_hours(*subjects) }
    end

    def to_md
      inject('') { |s, d| s += "#{d.to_md}\n" }
    end

    def to_ssv
      inject('') do |s, d|
        s += if block_given?
          "#{d.to_ssv { |key| yield(key) }}"
        else
          "#{d.to_ssv}"
        end
      end
    end

    def time_worked_to_ssv
      string = ''
      time_worked.each do |k,j|
        string += format(
          "%-30s%10s\n",
          (
            if block_given?
              yield(k)
            else
              k
            end
          ),
          format("%0.2f", j.total / 3600.0)
        )
      end
      string
    end

    def work_days_by_weeks
      (0..length / 7).inject([]) do |array, week|
        week_start = 7*week
        week_end = week_start+6
        days = self[week_start..week_end]
        next array if days.empty?

        array << WorkDayCollection.new(*days)
        yield array.last if block_given?
        array
      end
    end

    def hours_per_day_by_weeks(*task_types)
      array = []
      work_days_by_weeks do |week|
        array << (
          week.map do |day|
            day.to_hours(*task_types)
          end
        )
        yield array.last if block_given?
      end
      array
    end

    def hours_per_week(*task_types)
      hours = []
      hours_per_day_by_weeks(*task_types) do |week|
        hours << week.inject(:+)
      end
      hours
    end

    def subjects
      map { |day| day.tasks.map { |task| task.subject } }.flatten.sort.uniq
    end

    def hours_per_week_ssv(*task_types)
      string = ''
      hours = []
      week = 1
      work_days_by_weeks do |week_collection|
        subjects_this_week = week_collection.subjects
        unless task_types.empty?
          subjects_this_week &= task_types
        end
        string += (
          "# #{week_collection.first.date.strftime('%b %-d, %Y')}\n" +
          "# #{subjects_this_week.join(', ')}\n"
        )
        week_hours = week_collection.map do |day|
          day.to_hours(*task_types)
        end
        hours << week_hours.inject(:+)
        string += (
          "# " + week_hours.join(', ') + "\n" +
          format("%-10d%0.2f\n", week, hours.last)
        )
        week += 1
      end
      string += format("%-10s%0.2f\n", 'Avg', hours.inject(:+) / hours.length)
    end
  end
end
