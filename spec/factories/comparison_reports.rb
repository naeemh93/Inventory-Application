# frozen_string_literal: true

FactoryBot.define do
  factory :comparison_report do
    association :inventory_storage
    after(:build) do |report|
      report.report_file.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_report.pdf')),
        filename: 'test_report.pdf',
        content_type: 'application/pdf'
      )
    end
  end
end
