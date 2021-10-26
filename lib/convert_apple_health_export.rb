# frozen_string_literal: true

require_relative "convert_apple_health_export/convert_xml"
require_relative "convert_apple_health_export/create_csv"
require_relative "convert_apple_health_export/build_records"
require_relative "convert_apple_health_export/parse_xml"
require_relative "convert_apple_health_export/record"
require_relative "convert_apple_health_export/version"

module ConvertAppleHealthExport
  class Error < StandardError; end
end
