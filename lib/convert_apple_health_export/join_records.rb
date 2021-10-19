module JoinRecords
  extend self

  def call(diastolic_records, systolic_records)
    records = diastolic_records.each_with_object([]) do |record, accu|
      pair = find_matching_value(record["startDate"], systolic_records)
      accu << Record.new(record["value"], pair, record["startDate"])
    end

    records.uniq { |p| p.time }.sort_by(&:time)
  end

  private

  def find_matching_value(date, records)
    matching_systolic_item = records.find { |sr| sr["startDate"] == date }
    matching_systolic_item["value"]
  end
end
