# frozen_string_literal: true

module Api
  class InventoryStoragesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :validate_json_file, only: [:create]

    def create
      if @valid_file
        inventory_storage = InventoryStorage.new(title: params[:file].original_filename + "_#{Time.now}")
        inventory_storage.robot_file.attach(params[:file])
        if inventory_storage.save
          render json: inventory_storage, status: :ok
        else
          render json: inventory_storage.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid JSON file contents according to schema' }, status: :unprocessable_entity
      end
    end

    private

    def render_invalid_file_error
      render json: { error: 'Invalid JSON file contents according to schema' }, status: :unprocessable_entity
    end

    def create_inventory_storage
      @inventory_storage = InventoryStorage.new(title: formatted_title)
      @inventory_storage.robot_file.attach(params[:file])
      @inventory_storage.save
    end

    def formatted_title
      "#{params[:file].original_filename}_#{Time.now}"
    end

    def validate_json_file
      file = params[:file]
      schema_path = 'app/schemas/robot_schema.json'
      unless file.present? && File.extname(file.original_filename).downcase == '.json'
        render json: { error: 'Invalid or missing JSON file' }, status: :unprocessable_entity
        return
      end
      @valid_file = FileValidationService.validate_json(file:, schema_path: Rails.root.join(schema_path))
    end
  end
end
