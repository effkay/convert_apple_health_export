require "csv"

module CreateCSV
  extend self

  def call(records, path)
    CSV.open(path, "wb") do |csv|
      csv << %w[time diastolic systolic]
      records.each do |record|
        csv << record.to_csv
      end
    end
  end
end
