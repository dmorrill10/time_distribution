require_relative 'support/spec_helper'

require 'time_distribution/work_day'

include TimeDistribution
describe WorkDay do
  before do
    t1 = MiniTest::Mock.new
    t2 = MiniTest::Mock.new
    @x_date = 'May 7, 2013'
    @x_tasks = [t1, t2]
    @patient = WorkDay.new @x_date, @x_tasks

    @patient.date.must_equal Chronic.parse(@x_date)
    @patient.tasks.must_equal @x_tasks
  end
  describe '#add_task!' do
    it 'works' do
      t3 = MiniTest::Mock.new
      @patient.add_task!(t3).must_equal @patient
      @patient.tasks.must_equal (@x_tasks << t3)
    end
  end
  describe 'time_worked' do
    it 'works' do
      time_taken_for_each_task = 23
      x_subject = 'my subject'
      @x_tasks.each do |mock_task|
        mock_task.expect(:subject, x_subject)
        mock_task.expect(:subject, x_subject)
        mock_task.expect(:subject, x_subject)
        mock_task.expect(:time_taken, time_taken_for_each_task)
      end
      @patient.time_worked.must_equal ({x_subject => Duration.new(@x_tasks.length * time_taken_for_each_task)})
    end
  end
end