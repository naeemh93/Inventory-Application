require 'csv'
require 'json-schema'

class FileValidationService
  CSV_REQUIRED_HEADERS = [:location, :item].freeze

  # Validates CSV file
  def self.validate_csv(file)
    content = file.read
    csv = CSV.parse(content, headers: true, header_converters: :symbol)
    #todo: we can also validate check for the location name format if needed.
    CSV_REQUIRED_HEADERS.all? { |header| csv.headers.include?(header) }
  rescue
    false
  end

  # Validates JSON file against a schema
  def self.validate_json(file:, schema_path:)
    json_data = JSON.parse(file.read)
    schema = JSON.parse(File.read(schema_path))

    JSON::Validator.validate(schema, json_data, strict: true)
  rescue JSON::Schema::ValidationError, JSON::ParserError
    false
  end
end
