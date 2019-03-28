require 'nokogiri'
require 'csv'

class Record
  attr_accessor :diastolic, :systolic, :time

  def initialize(diastolic, systolic, time)
    @diastolic = diastolic
    @systolic = systolic
    @time = time
  end

  def to_csv
    [time, diastolic, systolic]
  end
end

module ParseXML
  extend self

  XPATH_DIASTOLIC = "//Record[contains(@type,'HKQuantityTypeIdentifierBloodPressureDiastolic')]"
  XPATH_SYSTOLIC = "//Record[contains(@type,'HKQuantityTypeIdentifierBloodPressureSystolic')]"

  def call(path)
    document = File.open(path) { |f| Nokogiri::XML(f) }
    diastolic_records = document.xpath(XPATH_DIASTOLIC).map(&:to_h)
    systolic_records = document.xpath(XPATH_SYSTOLIC).map(&:to_h)

    [diastolic_records, systolic_records]
  end
end

module CreateCSV
  extend self

  def call(records, path)
    records = records.sort_by(&:time)

    CSV.open(path, 'wb') do |csv|
      csv << %w[time diastolic systolic]
      records.each do |record|
        csv << record.to_csv
      end
    end
  end
end

module JoinRecords
  extend self

  def call(diastolic_records, systolic_records)
    records = diastolic_records.each_with_object([]) do |record, accu|
      pair = find_matching_value(record['startDate'], systolic_records)
      accu << Record.new(record['value'], pair, record['startDate'])
    end

    records.uniq { |p| p.time }
  end

  private

  def find_matching_value(date, records)
    matching_systolic_item = records.find { |sr| sr['startDate'] == date }
    matching_systolic_item['value']
  end
end

module ConvertXML
  extend self

  def call(input_path, export_path)
    diastolic_records, systolic_records = ParseXML.call(input_path)
    records = JoinRecords.call(diastolic_records, systolic_records)

    puts "Found #{records.count} records, creating CSV"

    CreateCSV.call(records, export_path)
  end
end

ConvertXML.call('export.xml', 'export.csv')
