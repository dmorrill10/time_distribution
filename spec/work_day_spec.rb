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
    describe 'returns a hash of duration sums without arguments' do
      it 'when all tasks have the same subject' do
        time_taken_for_each_task = 23
        x_subject = 'my subject'
        @x_tasks.each do |mock_task|
          mock_task.expect(:subject, x_subject)
          mock_task.expect(:time_taken, time_taken_for_each_task)
        end
        @patient.time_worked.must_equal (Duration.new(@x_tasks.length * time_taken_for_each_task))
      end
      it 'when more than one subject is present' do
        time_taken_for_each_task = 23
        subject_1 = 'subject 1'
        @x_tasks.each do |mock_task|
          mock_task.expect(:subject, subject_1)
          mock_task.expect(:time_taken, time_taken_for_each_task)
        end
        num_subject_1_tasks = @x_tasks.length
        t3 = MiniTest::Mock.new
        subject_2 = 'subject 2'
        t3.expect(:subject, subject_2)
        t3.expect(:time_taken, time_taken_for_each_task)
        @x_tasks << t3
        t4 = MiniTest::Mock.new
        subject_3 = 'subject 3'
        t4.expect(:subject, subject_3)
        t4.expect(:time_taken, time_taken_for_each_task)
        @x_tasks << t4

        @patient.time_worked.must_equal (
          {
            subject_1 => Duration.new(num_subject_1_tasks * time_taken_for_each_task),
            subject_2 => Duration.new(time_taken_for_each_task),
            subject_3 => Duration.new(time_taken_for_each_task)
          }
        )
      end
    end
    it 'returns a hash of duration sums when given a list of subjects' do
      time_taken_for_each_task = 23
      subject_1 = 'subject 1'
      @x_tasks.each do |mock_task|
        mock_task.expect(:subject, subject_1)
        mock_task.expect(:time_taken, time_taken_for_each_task)
      end
      num_subject_1_tasks = @x_tasks.length
      t3 = MiniTest::Mock.new
      subject_2 = 'subject 2'
      t3.expect(:subject, subject_2)
      t3.expect(:time_taken, time_taken_for_each_task)
      @x_tasks << t3
      t4 = MiniTest::Mock.new
      subject_3 = 'subject 3'
      t4.expect(:subject, subject_3)
      @x_tasks << t4

      @patient.time_worked([subject_1, subject_2]).must_equal (
        {
          subject_1 => Duration.new(num_subject_1_tasks * time_taken_for_each_task),
          subject_2 => Duration.new(time_taken_for_each_task)
        }
      )
    end
    describe 'returns a single sum given a subject' do
      it 'as a scalar' do
        time_taken_for_each_task = 23
        subject_1 = 'subject 1'
        @x_tasks.each do |mock_task|
          mock_task.expect(:subject, subject_1)
          mock_task.expect(:time_taken, time_taken_for_each_task)
        end
        num_subject_1_tasks = @x_tasks.length
        t3 = MiniTest::Mock.new
        subject_2 = 'subject 2'
        t3.expect(:subject, subject_2)
        t3.expect(:time_taken, time_taken_for_each_task)
        @x_tasks << t3
        t4 = MiniTest::Mock.new
        subject_3 = 'subject 3'
        t4.expect(:subject, subject_3)
        @x_tasks << t4

        @patient.time_worked(subject_1).must_equal (
          Duration.new(num_subject_1_tasks * time_taken_for_each_task)
        )
      end
      it 'as a single element list' do
      end
    end
  end
end