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
      inject('') { |s, d| s += "#{d.to_ssv}" }
    end
  end
end
