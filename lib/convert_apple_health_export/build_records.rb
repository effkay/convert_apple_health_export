module BuildRecords
  extend self

  def call(diastolic_entries, systolic_entries)
    entries = diastolic_entries.each_with_object([]) do |entry, accu|
      pair = find_matching_value(entry["startDate"], systolic_entries)
      accu << Record.new(entry["value"], pair, entry["startDate"])
    end

    entries.uniq { |p| p.time }.sort_by(&:time)
  end

  private

  def find_matching_value(date, entries)
    matching_systolic_item = entries.find { |sr| sr["startDate"] == date }
    matching_systolic_item["value"]
  end
end
