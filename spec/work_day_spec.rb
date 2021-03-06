require_relative 'support/spec_helper'
require 'yaml'

require 'time_distribution/work_day'
require 'time_distribution/task'

include TimeDistribution


describe WorkDay do
  let(:yml_string_data) do
    <<-END
date: April 21, 2016
tasks:
  -
    subject: :time_distribution
    duration: 6:38pm to 7pm
    description: |
      - Comment 1
      - Comment 2
  -
    subject: :aaaaaa
    duration: 4:38am to 6pm
    description: |
      - Ahdkjlan akjdlnkfn
END
  end


  describe '#from_map' do
    let(:patient) do
      map_data = YAML.load(yml_string_data)
      _patient = WorkDay.from_map map_data
      _patient.date.must_equal Chronic.parse(map_data['date'])
      _patient.tasks.must_equal map_data['tasks'].map { |t| Task.from_map t }
      _patient
    end
    it 'works' do
      patient
    end
  end


  let(:x_tasks) { [MiniTest::Mock.new, MiniTest::Mock.new] }
  let(:x_date) { 'May 7, 2013' }
  let(:patient) do
    _patient = WorkDay.new x_date, *x_tasks
    _patient.date.must_equal Chronic.parse(x_date)
    _patient.tasks.must_equal x_tasks
    _patient
  end


  describe 'to_hours' do
    it 'works without argument' do
      x_tasks[0].expect(:to_hours, 1.1)
      x_tasks[1].expect(:to_hours, 2.6)
      patient.to_hours.must_equal 1.1 + 2.6
    end
    it 'works with arguments' do
      x_tasks[0].expect(:to_hours, 1.1)
      x_tasks[1].expect(:to_hours, 2.6)
      x_tasks[0].expect(:subject, :relevant_task)
      x_tasks[1].expect(:subject, :irrelevant_task)
      patient.to_hours(:relevant_task).must_equal 1.1

      x_tasks[0].expect(:to_hours, 1.1)
      x_tasks[1].expect(:to_hours, 2.6)
      x_tasks[0].expect(:subject, :relevant_task)
      x_tasks[1].expect(:subject, :irrelevant_task)
      patient.to_hours(:irrelevant_task).must_equal 2.6

      x_tasks[0].expect(:to_hours, 1.1)
      x_tasks[1].expect(:to_hours, 2.6)
      x_tasks[0].expect(:subject, :relevant_task)
      x_tasks[1].expect(:subject, :irrelevant_task)
      patient.to_hours(:relevant_task, :irrelevant_task).must_equal 1.1 + 2.6
    end
  end
  describe 'to_md' do
    it 'works' do
      x_tasks[0].expect(:to_s, 'Task 1')
      x_tasks[1].expect(:to_s, 'Task 2')
      patient.to_md.must_equal (
<<-END
#{x_date}
============================
- Task 1
- Task 2
END
      )
    end
  end
  describe '#add_task!' do
    it 'works' do
      t3 = MiniTest::Mock.new
      patient.add_task!(t3).must_equal patient
      patient.tasks.must_equal (x_tasks << t3)
    end
  end
  describe 'time_worked' do
    describe 'returns a hash of duration sums without arguments' do
      it 'when all tasks have the same subject' do
        time_taken_for_each_task = 23
        x_subject = 'my subject'
        x_tasks.each do |mock_task|
          mock_task.expect(:subject, x_subject)
          mock_task.expect(:time_taken, time_taken_for_each_task)
        end
        patient.time_worked.must_equal ({x_subject => (Duration.new(x_tasks.length * time_taken_for_each_task)) })
      end
      it 'when more than one subject is present' do
        time_taken_for_each_task = 23
        subject_1 = 'subject 1'
        x_tasks.each do |mock_task|
          mock_task.expect(:subject, subject_1)
          mock_task.expect(:time_taken, time_taken_for_each_task)
        end
        num_subject_1_tasks = x_tasks.length
        t3 = MiniTest::Mock.new
        subject_2 = 'subject 2'
        t3.expect(:subject, subject_2)
        t3.expect(:time_taken, time_taken_for_each_task)
        x_tasks << t3
        t4 = MiniTest::Mock.new
        subject_3 = 'subject 3'
        t4.expect(:subject, subject_3)
        t4.expect(:time_taken, time_taken_for_each_task)
        x_tasks << t4

        patient = WorkDay.new x_date, x_tasks

        patient.time_worked.must_equal (
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
      x_tasks.each do |mock_task|
        mock_task.expect(:subject, subject_1)
        mock_task.expect(:time_taken, time_taken_for_each_task)
      end
      num_subject_1_tasks = x_tasks.length
      t3 = MiniTest::Mock.new
      subject_2 = 'subject 2'
      t3.expect(:subject, subject_2)
      t3.expect(:time_taken, time_taken_for_each_task)
      x_tasks << t3
      t4 = MiniTest::Mock.new
      subject_3 = 'subject 3'
      t4.expect(:subject, subject_3)
      x_tasks << t4

      patient = WorkDay.new x_date, x_tasks

      patient.time_worked(subject_1, subject_2).must_equal (
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
        x_tasks.each do |mock_task|
          mock_task.expect(:subject, subject_1)
          mock_task.expect(:time_taken, time_taken_for_each_task)
        end
        num_subject_1_tasks = x_tasks.length
        t3 = MiniTest::Mock.new
        subject_2 = 'subject 2'
        t3.expect(:subject, subject_2)
        t3.expect(:time_taken, time_taken_for_each_task)
        x_tasks << t3
        t4 = MiniTest::Mock.new
        subject_3 = 'subject 3'
        t4.expect(:subject, subject_3)
        x_tasks << t4

        patient = WorkDay.new x_date, x_tasks

        patient.time_worked(subject_1).must_equal (
          {subject_1 => Duration.new(num_subject_1_tasks * time_taken_for_each_task)}
        )
      end
    end
  end
end
