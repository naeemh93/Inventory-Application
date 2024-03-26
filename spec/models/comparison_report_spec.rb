# spec/models/comparison_report_spec.rb
require 'rails_helper'

RSpec.describe ComparisonReport, type: :model do
  it { should belong_to(:inventory_storage) }

  describe 'attached report_file' do
    it 'is valid with a report_file attached' do
      report = create(:comparison_report)

      expect(report).to be_valid
      expect(report.report_file).to be_attached
    end
  end
end
