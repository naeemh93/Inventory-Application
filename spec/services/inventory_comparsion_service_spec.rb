require 'rails_helper'
require 'json'
require 'csv'
RSpec.describe InventoryComparisonService do
  # Mocking the InventoryStorage to return specific file contents
  let(:inventory_storage) { instance_double("InventoryStorage") }
  let(:robot_file_content) do
    # Example JSON content
    [
      { "name": "ZA001A", "occupied": true,"scanned":true, "detected_barcodes": ["DX9850004338"] },
      { "name": "ZA002A", "occupied": false,"scanned":true, "detected_barcodes": [] },
    ].to_json
  end
  let(:customer_file_content) do
    # Example CSV content
    "LOCATION,ITEM\nZA001A,DX9850004338\nZA002A,\n"
  end

  before do
    allow(inventory_storage).to receive_message_chain(:robot_file, :download).and_return(robot_file_content)
    allow(inventory_storage).to receive_message_chain(:customer_file, :download).and_return(customer_file_content)
  end

  subject(:service) { described_class.new(inventory_storage).call }

  it 'correctly identifies an occupied location with the expected item' do
    location_entry = service.find { |entry| entry[:name] == 'ZA001A' }

    expect(location_entry).to include(
                                name: 'ZA001A',
                                scanned: true,
                                occupied: true,
                                expected_barcodes: 'DX9850004338',
                                detected_barcodes: 'DX9850004338',
                                comparison_result: 'The location was occupied by the expected items'
                              )
  end

  it 'correctly identifies an empty location, as expected' do
    location_entry = service.find { |entry| entry[:name] == 'ZA002A' }

    expect(location_entry).to include(
                                name: 'ZA002A',
                                scanned: true,
                                occupied: false,
                                expected_barcodes: nil,
                                detected_barcodes: '',
                                comparison_result: 'The location was empty, as expected'
                              )
  end


end
