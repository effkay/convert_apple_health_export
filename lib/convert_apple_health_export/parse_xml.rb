require "nokogiri"

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
