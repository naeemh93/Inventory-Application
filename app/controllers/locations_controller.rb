class LocationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_csv_file, only: [:upload_customer_csv]

  def index
    @inventory_storages = InventoryStorage.all
  end

  def new_file_upload
    @inventory_storage = InventoryStorage.find(params[:id])
  end

  def upload_customer_csv
    is = InventoryStorage.find(params[:id])
    is.update(customer_file: params[:inventory_storage][:customer_file])
    InventoryServiceJob.perform_later(is)
    respond_to do |format|
      format.html { redirect_to locations_path, notice: 'CSV uploaded and processed successfully.' }
      format.json { render json: { notice: 'CSV uploaded and processed successfully.' }, status: :ok }
    end
  end

  private

  def validate_csv_file
    file =params[:inventory_storage][:customer_file]
    if file.present? && File.extname(file.original_filename).downcase == '.csv' && FileValidationService.validate_csv(file)
      true
    else
      respond_to do |format|
        format.html { redirect_to new_file_location_path, notice: 'Invalid or missing CSV file, or file does not meet the required format.' }
        format.json { render json: { error: 'Invalid or missing CSV file, or file does not meet the required format' }, status: :unprocessable_entity }
      end
      false
    end
  end

end
