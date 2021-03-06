require_relative 'support/spec_helper'

require 'time_distribution/work_day_collection'
require 'time_distribution/work_day'

include TimeDistribution


describe WorkDayCollection do
  let(:yml_string_data) do
    <<-END
---
-
  date: April 21, 2016
  tasks:
    -
      subject: time_distribution
      duration: 6:38pm to 7pm
      description: |
        - Comment 1
        - Comment 2
    -
      subject: aaaaaa
      duration: 4:38am to 6pm
      description: |
        - Ahdkjlan akjdlnkfn
-
  date: April 20, 2016
  tasks:
    -
      subject: time_distribution
      duration: 6:38pm to 7pm
      description: |
        - Comment 3
        - Comment 4
    -
      subject: bbbbb
      duration: 4:38am to 6pm
      description: |
        - jkljkljlkj syowueiorue
END
  end

  let(:patient) do
    map_data = YAML.load(yml_string_data)
    _patient = WorkDayCollection.from_map map_data
    _patient.must_equal map_data.map { |t| WorkDay.from_map t }
    _patient
  end

  describe '#from_map' do
    it 'works' do
      patient
    end
  end

  describe '#days_to_yaml' do
    it 'works' do
      patient.must_equal WorkDayCollection.from_map YAML.load(patient.days_to_yaml)
    end
  end

  describe '#new' do
    it 'with days only' do
      patient = WorkDayCollection.new('d1', 'd2')
      patient.to_a.must_equal ['d1', 'd2']
      patient.official_work_days.must_equal ({
        january: 0,
        february: 0,
        march: 0,
        april: 0,
        may: 0,
        june: 0,
        july: 0,
        august: 0,
        september: 0,
        october: 0,
        november: 0,
        december: 0
      })
      patient.respond_to?(:set_official_work_days_in_january!).must_equal true
      patient.respond_to?(:set_official_work_days_in_february!).must_equal true
      patient.respond_to?(:set_official_work_days_in_march!).must_equal true
      patient.respond_to?(:set_official_work_days_in_april!).must_equal true
      patient.respond_to?(:set_official_work_days_in_may!).must_equal true
      patient.respond_to?(:set_official_work_days_in_june!).must_equal true
      patient.respond_to?(:set_official_work_days_in_july!).must_equal true
      patient.respond_to?(:set_official_work_days_in_august!).must_equal true
      patient.respond_to?(:set_official_work_days_in_september!).must_equal true
      patient.respond_to?(:set_official_work_days_in_october!).must_equal true
      patient.respond_to?(:set_official_work_days_in_november!).must_equal true
      patient.respond_to?(:set_official_work_days_in_december!).must_equal true
    end
    it 'with days and official work schedule' do
      x_official_work_days = {
        january: 0,
        february: 20,
        march: 0,
        april: 30,
        may: 14,
        june: 0,
        july: 0,
        august: 16,
        september: 0,
        october: 0,
        november: 0,
        december: 12
      }
      patient = WorkDayCollection.new('d1', 'd2', official_work_days: x_official_work_days.dup)
      patient.to_a.must_equal ['d1', 'd2']
      patient.official_work_days.must_equal  x_official_work_days
      patient.respond_to?(:set_official_work_days_in_january!).must_equal true
      patient.respond_to?(:set_official_work_days_in_february!).must_equal true
      patient.respond_to?(:set_official_work_days_in_march!).must_equal true
      patient.respond_to?(:set_official_work_days_in_april!).must_equal true
      patient.respond_to?(:set_official_work_days_in_may!).must_equal true
      patient.respond_to?(:set_official_work_days_in_june!).must_equal true
      patient.respond_to?(:set_official_work_days_in_july!).must_equal true
      patient.respond_to?(:set_official_work_days_in_august!).must_equal true
      patient.respond_to?(:set_official_work_days_in_september!).must_equal true
      patient.respond_to?(:set_official_work_days_in_october!).must_equal true
      patient.respond_to?(:set_official_work_days_in_november!).must_equal true
      patient.respond_to?(:set_official_work_days_in_december!).must_equal true
    end
  end

  describe '#time_worked' do
    it 'works' do
      patient = new_full_patient
      patient.time_worked.must_equal ({
        :taxes => Duration.new(14760),
            :cmput659 => Duration.new(31920),
                :cprg => Duration.new(3600),
    :masters_research => Duration.new(3600)
      })
    end
  end

  describe '#avg_hours_per_official_work_day' do
    it 'works without argument' do
      patient = new_full_patient
      patient.avg_hours_per_official_work_day.must_equal (
        14.9666666666666667 / (1 + 20 + 10 + 30 + 14 + 0 + 0 + 16 + 0 + 0 + 0 + 12)
      )
    end
    it 'works with arguments' do
      patient = new_full_patient
      patient.avg_hours_per_official_work_day(:cprg, :taxes).must_equal (
        5.1 / (1 + 20 + 10 + 30 + 14 + 0 + 0 + 16 + 0 + 0 + 0 + 12)
      )
    end
  end

  describe '#hours' do
    it 'works without argument' do
      patient = new_full_patient
      patient.hours.must_equal 14.9666666666666667
    end
    it 'works with argument' do
      patient = new_full_patient
      patient.hours(:cprg, :taxes).must_equal 5.1
    end
  end

  describe '#avg_hours_per_day_worked' do
    it 'works without argument' do
      patient = new_full_patient
      patient.avg_hours_per_day_worked.must_equal 14.9666666666666667 / 2.0
    end
    it 'works without argument' do
      patient = new_full_patient
      patient.avg_hours_per_day_worked(:cprg, :taxes).must_equal 5.1 / 2.0
    end
  end

  describe '#to_md' do
    it 'works' do
      patient = new_full_patient
      patient.to_md.must_equal (
<<-END
Mar 14, 2015
============================
- 2.60 hours of taxes: Worked on taxes some more
- 1.50 hours of taxes: Worked on taxes

Mar 13, 2015
============================
- 6.92 hours of cmput659: Finished A7. Used my fourth late day, so I have one left for two assignments
- 1.00 hours of cprg: Fixed a bug in no-limit interface
- 1.00 hours of masters_research: Attended AI lecture by Gabor on theory related to convex regression
- 0.25 hours of cmput659: Listened to a Koller lecture
- 1.70 hours of cmput659: Worked on A7

END
)
    end
  end

  describe '#to_ssv' do
    it 'works' do
      patient = new_full_patient
      patient.to_ssv.must_equal (
<<-END
# Mar 14, 2015
taxes                               2.60
taxes                               1.50
# Mar 13, 2015
cmput659                            6.92
cprg                                1.00
masters_research                    1.00
cmput659                            0.25
cmput659                            1.70
END
)
    end
  end

  describe '#time_worked_to_ssv' do
    it 'works' do
      patient = new_full_patient
      patient.time_worked_to_ssv do |subject|
        subject.to_s.split('_').collect(&:capitalize).join
      end.must_equal (
<<-END
Taxes                               4.10
Cmput659                            8.87
Cprg                                1.00
MastersResearch                     1.00
END
      )
    end
  end

  describe '#work_days_by_weeks' do
    it 'works' do
      patient = new_full_patient
      patient.work_days_by_weeks.flatten.must_equal patient
    end
  end

  describe '#hours_per_day_by_weeks' do
    it 'works' do
      patient = new_full_patient
      patient.hours_per_day_by_weeks.must_equal [[4.1, 10.866666666666667]]
    end
  end

  describe '#hours_per_week' do
    it 'works' do
      patient = new_full_patient
      patient.hours_per_week.must_equal [4.1 + 10.866666666666667]
    end
  end

  describe '#subjects' do
    it 'works' do
      patient = new_full_patient
      patient.subjects.must_equal [:taxes, :cmput659, :cprg, :masters_research].sort
    end
  end

  describe '#hours_per_week_ssv' do
    it 'works' do
      patient = new_full_patient
      patient.hours_per_week_ssv.must_equal (
<<-END
# Mar 14, 2015
# cmput659, cprg, masters_research, taxes
# 4.1, 10.866666666666667
1         14.97
Avg       14.97
END
      )
    end
  end

  def new_full_patient
    WorkDayCollection.new(
      WorkDay.new(
        'March 14, 2015',
        [
          Task.new(
            :taxes,
            '12:54pm to 3:30pm',
            "
            Worked on taxes some more
            "
          ),
          Task.new(
            :taxes,
            '11am to 12:30pm',
            "
            Worked on taxes
            "
          )
        ]
      ),
      WorkDay.new(
        'March 13, 2015',
        [
          Task.new(
            :cmput659,
            '5:30pm to 12:25am',
            "
            Finished A7. Used my fourth late day, so I have one left for two assignments
            "
          ),
          Task.new(
            :cprg,
            '1 hour',
            "
            Fixed a bug in no-limit interface
            "
          ),
          Task.new(
            :masters_research,
            '12pm to 1pm',
            "
            Attended AI lecture by Gabor on theory related to convex regression
            "
          ),
          Task.new(
            :cmput659,
            '11:35am to 11:50am',
            "
            Listened to a Koller lecture
            "
          ),
          Task.new(
            :cmput659,
            '9:53am to 11:35am',
            "
            Worked on A7
            "
          )
        ]
      ),
      official_work_days: {
        january: 1,
        february: 20,
        march: 10,
        april: 30,
        may: 14,
        june: 0,
        july: 0,
        august: 16,
        september: 0,
        october: 0,
        november: 0,
        december: 12
      }
    )
  end
end
