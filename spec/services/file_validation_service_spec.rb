require 'rails_helper'

RSpec.describe FileValidationService do
  let(:valid_csv) { "location,item\nNew York,Apple" }
  let(:invalid_csv_missing_headers) { "item,quantity\nApple,10" }
  let(:invalid_csv_empty) { "" }
  let(:valid_json) { { name: 'ZA001A', occupied: true }.to_json }
  let(:invalid_json_missing_keys) { { name: 'ZA001A' }.to_json }
  let(:invalid_json_empty) { {}.to_json }
  let(:schema_path) { Rails.root.join('spec','fixtures','files', 'validation_schema.json') }

  describe '.validate_csv' do
    it 'validates CSV with correct headers' do
      expect(described_class.validate_csv(StringIO.new(valid_csv))).to be true
    end

    it 'rejects CSV missing required headers' do
      expect(described_class.validate_csv(StringIO.new(invalid_csv_missing_headers))).to be false
    end

    it 'rejects empty CSV content' do
      expect(described_class.validate_csv(StringIO.new(invalid_csv_empty))).to be false
    end
  end

  describe '.validate_json' do
    before do
      File.write(schema_path, {
        type: 'object',
        required: ['name', 'occupied'],
        properties: {
          name: { type: 'string' },
          occupied: { type: 'boolean' }
        }
      }.to_json)
    end

    it 'validates JSON matching the schema' do
      expect(described_class.validate_json(file: StringIO.new(valid_json), schema_path: schema_path)).to be true
    end

    it 'rejects JSON missing required keys' do
      expect(described_class.validate_json(file: StringIO.new(invalid_json_missing_keys), schema_path: schema_path)).to be false
    end

    it 'rejects empty JSON content' do
      expect(described_class.validate_json(file: StringIO.new(invalid_json_empty), schema_path: schema_path)).to be false
    end
  end
end
