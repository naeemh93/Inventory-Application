# frozen_string_literal: true

# spec/models/inventory_storage_spec.rb
require 'rails_helper'

RSpec.describe InventoryStorage, type: :model do
  it { should have_one(:comparison_report) }

  describe 'attachments' do
    let(:storage) { create(:inventory_storage) }

    context 'when robot_file is not JSON' do
      before do
        storage.robot_file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_report.pdf')),
                                  filename: 'test_report.pdf', content_type: 'application/pdf')
      end

      it 'is not valid' do
        expect(storage).not_to be_valid
        expect(storage.errors[:robot_file]).to include('must be a JSON file')
      end
    end

    context 'when customer_file is not JSON' do
      before do
        storage.customer_file.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_report.pdf')),
                                     filename: 'test_report.pdf', content_type: 'application/pdf')
      end

      it 'is not valid' do
        expect(storage).not_to be_valid
        expect(storage.errors[:customer_file]).to include('must be a JSON file')
      end
    end
  end
end
