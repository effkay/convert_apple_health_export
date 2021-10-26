module ConvertXML
  extend self

  def call(input_path, export_path)
    diastolic_records, systolic_records = ParseXML.call(input_path)
    records = BuildRecords.call(diastolic_records, systolic_records)

    puts "Found #{records.count} records, creating CSV"

    CreateCSV.call(records, export_path)
  end
end
