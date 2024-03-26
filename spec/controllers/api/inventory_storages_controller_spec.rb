# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::InventoryStoragesController, type: :request do
  describe 'POST /api/inventory_storages' do
    let(:valid_json_file) { fixture_file_upload('robot_generated_data.json', 'application/json') }
    let(:invalid_json_file) { fixture_file_upload('invalid_data.json', 'application/json') }
    let(:valid_params) { { file: valid_json_file } }
    let(:invalid_params) { { file: invalid_json_file } }

    context 'with valid JSON file' do
      before do
        allow(FileValidationService).to receive(:validate_json).and_return(true)
      end

      it 'creates a new inventory storage and attaches file' do
        expect do
          post '/api/inventory_storages', params: valid_params
        end.to change(ActiveStorage::Attachment, :count).by(1).and change(InventoryStorage, :count).by(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid JSON file format' do
      it 'returns an error for missing or invalid file' do
        post '/api/inventory_storages', params: {}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Invalid or missing JSON file')
      end
    end

    context 'with invalid JSON file contents' do
      before do
        allow(FileValidationService).to receive(:validate_json).and_return(false)
      end

      it 'returns an error for invalid JSON file contents according to schema' do
        post '/api/inventory_storages', params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('error' => 'Invalid JSON file contents according to schema')
      end
    end

    context 'when inventory storage fails to save' do
      before do
        allow(FileValidationService).to receive(:validate_json).and_return(true)
        allow_any_instance_of(InventoryStorage).to receive(:save).and_return(false)
      end

      it 'returns unprocessable entity status' do
        post '/api/inventory_storages', params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
