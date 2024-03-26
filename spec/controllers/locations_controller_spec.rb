# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationsController, type: :request do
  describe 'GET #index' do
    it 'returns a successful response' do
      get locations_path
      expect(response).to be_successful
    end
  end

  describe 'GET #new_file_upload' do
    context 'with valid inventory storage id' do
      let(:inventory_storage) { create(:inventory_storage) }

      it 'returns a successful response' do
        get new_file_location_path(inventory_storage.id)
        expect(response).to be_successful
      end
    end

    context 'with invalid inventory storage id' do
      it 'returns a not found response' do
        get new_file_location_path(100)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #upload_customer_csv' do
    let(:inventory_storage) { create(:inventory_storage) }
    let(:file) { fixture_file_upload('spec/fixtures/files/example_test.csv', 'text/csv') }
    let(:params) do
      {
        id: inventory_storage.id,
        inventory_storage: { customer_file: file }
      }
    end

    context 'when params are valid' do
      it 'uploads the CSV and enqueues a job' do
        expect do
          post upload_csv_location_path(inventory_storage), params:
        end.to have_enqueued_job(InventoryServiceJob)
        expect(response).to redirect_to(locations_path)
        expect(flash[:notice]).to eq('CSV uploaded and processed successfully.')
      end
    end
  end
end
