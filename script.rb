require 'byebug'
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

  def call(path)
    document = File.open(path) { |f| Nokogiri::XML(f) }
    diastolic_records = document.xpath("//Record[contains(@type,'HKQuantityTypeIdentifierBloodPressureDiastolic')]").map(&:to_h)
    systolic_records = document.xpath("//Record[contains(@type,'HKQuantityTypeIdentifierBloodPressureSystolic')]").map(&:to_h)

    [diastolic_records, systolic_records]
  end
end

module CreateCSV
  extend self

  def call(records)
    CSV.open('export.csv', 'wb') do |csv|
      records.each do |record|
        csv << record.to_csv
      end
    end
  end
end

module JoinRecords
  extend self

  def call(diastolic_records, systolic_records)
    diastolic_records.each_with_object([]) do |record, accu|
      matching_systolic_value = systolic_records.find { |sr| sr['startDate'] == record['startDate'] }['value']
      accu << Record.new(record['value'], matching_systolic_value, record['startDate'])
    end
  end
end

module ConvertXML
  extend self

  def call(path)
    diastolic_records, systolic_records = ParseXML.call(path)
    records = JoinRecords.call(diastolic_records, systolic_records)

    puts "Found #{records.count} records, creating CSV"

    CreateCSV.call(records)
  end
end

ConvertXML.call('export.xml')

# TODO: pass path to ConvertXML
# TODO: pass export csv path
# TODO: sort records by time
