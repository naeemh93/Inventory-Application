# frozen_string_literal: true

module CsvFileValidation
  extend ActiveSupport::Concern

  included do
    before_action :validate_csv_file, only: [:upload_customer_csv]
  end

  private

  def validate_csv_file
    file = params[:inventory_storage][:customer_file]
    unless file.present?
      respond_with_error('No file was uploaded.')
      return false
    end

    unless File.extname(file.original_filename).casecmp('.csv').zero?
      respond_with_error('The uploaded file is not a CSV file.')
      return false
    end

    unless FileValidationService.validate_csv(file)
      respond_with_error('The CSV file does not meet the required format.')
      return false
    end

    true
  end

  def respond_with_error(message)
    respond_to do |format|
      format.html { redirect_to new_file_location_path, notice: message }
      format.json { render json: { error: message }, status: :unprocessable_entity }
    end
  end
end
