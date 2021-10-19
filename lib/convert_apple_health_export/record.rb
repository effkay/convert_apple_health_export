require "time"

class Record
  attr_accessor :diastolic, :systolic, :time

  def initialize(diastolic, systolic, time)
    @diastolic = diastolic
    @systolic = systolic
    @time = time
  end

  def to_csv
    [formatted_time, diastolic, systolic]
  end

  private

  def formatted_time
    Time.parse(time).strftime("%Y-%d-%m %H:%M:%S").to_s
  end
end
