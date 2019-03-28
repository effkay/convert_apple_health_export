require 'byebug'
require 'nokogiri'

class Record
  attr_accessor :diastolic, :systolic, :time

  def initialize(diastolic, systolic, time)
    @diastolic = diastolic
    @systolic = systolic
    @time = time
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

module JoinRecords
  extend self

  def call(diastolic_records, systolic_records)
    diastolic_records.each_with_object([]) do |record, accu|
      matching_systolic_value = systolic_records.find { |sr| sr['startDate'] == record['startDate'] }['value']
      accu << Record.new(record['value'], matching_systolic_value, record['startDate'])
    end
  end
end


diastolic_records, systolic_records = ParseXML.call('export.xml')
records = JoinRecords.call(diastolic_records, systolic_records)

puts "Found #{records.count} records"
puts records.first.inspect
