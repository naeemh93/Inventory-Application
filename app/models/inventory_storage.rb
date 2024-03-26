# frozen_string_literal: true

class InventoryStorage < ApplicationRecord
  has_one_attached :robot_file
  has_one_attached :customer_file
  has_one :comparison_report

  validate :robot_file_type
  validate :customer_file_type

  private

  def robot_file_type
    return unless robot_file.attached? && !robot_file.content_type.in?(%w[application/json])

    errors.add(:robot_file, 'must be a JSON file')
  end

  def customer_file_type
    return unless customer_file.attached? && !customer_file.content_type.in?(%w[text/csv])

    errors.add(:customer_file, 'must be a CSV file')
  end
end
