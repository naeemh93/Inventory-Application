# frozen_string_literal: true

class ComparisonReport < ApplicationRecord
  belongs_to :inventory_storage
  has_one_attached :report_file
end
