# frozen_string_literal: true

# Refactored InventoryServiceJob class demonstrating best practices
class InventoryServiceJob < ApplicationJob
  # Perform the job with error handling
  def perform(inventory_storage)
    generate_report_for(inventory_storage)
  rescue StandardError => e
    handle_error(inventory_storage, e)
  end

  private

  # Main logic to generate and attach the report
  def generate_report_for(inventory_storage)
    ensure_comparison_report_exists(inventory_storage)

    report_data = fetch_comparison_report_data(inventory_storage)
    return unless report_data.present?

    csv_content = generate_csv_from(report_data)
    attach_report_to(inventory_storage, csv_content)
  end

  # Ensure a comparison report exists or create one
  def ensure_comparison_report_exists(inventory_storage)
    return if inventory_storage.comparison_report.present?

    inventory_storage.create_comparison_report(status: 'pending')
  end

  # Fetch comparison report data using InventoryComparisonService
  def fetch_comparison_report_data(inventory_storage)
    InventoryComparisonService.new(inventory_storage).call
  end

  # Generate CSV content from report data
  def generate_csv_from(report_data)
    CsvGenerationService.generate_csv_content(report_data)
  end

  # Create and attach the CSV report
  def attach_report_to(inventory_storage, csv_content)
    filename = generate_filename
    attach_csv_to_storage(inventory_storage, csv_content, filename)
    update_report_status(inventory_storage, 'completed')
  end

  # Handle errors during report generation
  def handle_error(inventory_storage, error)
    Rails.logger.error("Failed to generate inventory report: #{error.message}")
    update_report_status(inventory_storage, 'failed')
  end

  # Generate a filename for the report
  def generate_filename
    "inventory_report_#{Time.zone.now.to_i}.csv"
  end

  # Attach generated CSV content to inventory storage
  def attach_csv_to_storage(inventory_storage, csv_content, filename)
    inventory_storage.comparison_report.report_file.attach(
      io: StringIO.new(csv_content),
      filename:,
      content_type: 'text/csv'
    )
  end

  # Update the status of the comparison report
  def update_report_status(inventory_storage, status)
    ensure_comparison_report_exists(inventory_storage) unless status == 'failed'
    inventory_storage.comparison_report.update(status:)
  end
end
