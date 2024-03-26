# frozen_string_literal: true

require 'csv'
class CsvGenerationService
  def self.generate_csv_content(data)
    CSV.generate do |csv|
      csv << ['Location Name', 'Scanned', 'Occupied', 'Expected Barcodes', 'Detected Barcodes', 'Comparison Result']
      data.each do |details|
        csv << [details[:name], details[:scanned], details[:occupied], details[:expected_barcodes],
                details[:detected_barcodes], details[:comparison_result]]
      end
    end
  end
end
