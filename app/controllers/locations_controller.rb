# frozen_string_literal: true

class LocationsController < ApplicationController
  include CsvFileValidation
  skip_before_action :verify_authenticity_token

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
end
