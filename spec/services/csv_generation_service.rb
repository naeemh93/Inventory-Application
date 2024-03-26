# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvGenerationService do
  describe '.generate_csv_content' do
    context 'when there is no data' do
      it 'returns a CSV string with only headers' do
        data = []
        expected_csv = "Location Name,Scanned,Occupied,Expected Barcodes,Detected Barcodes,Comparison Result\n"
        expect(described_class.generate_csv_content(data)).to eq(expected_csv)
      end
    end

    context 'when there are multiple records' do
      it 'returns a CSV string with all records' do
        data = [
          { name: 'Location A', scanned: true, occupied: 1, expected_barcodes: 2, detected_barcodes: 2,
            comparison_result: 'Match' },
          { name: 'Location B', scanned: false, occupied: 2, expected_barcodes: 4, detected_barcodes: 3,
            comparison_result: 'Mismatch' }
        ]
        expected_csv = "Location Name,Scanned,Occupied,Expected Barcodes,Detected Barcodes,Comparison Result\n
                   Location A,true,1,2,2,Match\nLocation B,false,2,4,3,Mismatch\n"
        expect(described_class.generate_csv_content(data)).to eq(expected_csv)
      end
    end
  end
end
