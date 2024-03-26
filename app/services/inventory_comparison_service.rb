# frozen_string_literal: true

class InventoryComparisonService
  def initialize(inventory_storage)
    @inventory_storage = inventory_storage
  end

  def call
    compare_data
  end

  private

  def parsed_json_data
    @parsed_json_data ||= JSON.parse(@inventory_storage.robot_file.download)
  end

  def parsed_csv_data
    @parsed_csv_data ||= CSV.parse(@inventory_storage.customer_file.download, headers: true).map(&:to_h)
  end

  def compare_data
    parsed_json_data.map do |location|
      expected_barcode = expected_barcodes_hash[location['name']]
      comparison_result = determine_comparison_result(location, expected_barcode)

      build_report_entry(location, expected_barcode, comparison_result)
    end
  end

  def expected_barcodes_hash
    @expected_barcodes_hash ||= parsed_csv_data.each_with_object({}) do |row, hash|
      hash[row['LOCATION']] = row['ITEM'].presence
    end
  end

  def determine_comparison_result(location, expected_barcode)
    detected_barcodes = location['detected_barcodes']&.join(', ')

    if location['occupied']
      if expected_barcode.nil?
        'The location was occupied by an item, but should have been empty'
      elsif detected_barcodes.nil?
        'The location was occupied, but no barcode could be identified'
      elsif expected_barcode == detected_barcodes
        'The location was occupied by the expected items'
      else
        'The location was occupied by the wrong items'
      end
    else
      expected_barcode.nil? ? 'The location was empty, as expected' : 'The location was empty, but it should have been occupied'
    end
  end

  def build_report_entry(location, expected_barcode, comparison_result)
    {
      name: location['name'],
      scanned: location['scanned'],
      occupied: location['occupied'],
      expected_barcodes: expected_barcode,
      detected_barcodes: location['detected_barcodes']&.join(', '),
      comparison_result:
    }
  end
end
