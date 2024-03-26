class InventoryStorage < ApplicationRecord
  has_one_attached :robot_file
  has_one_attached :customer_file
  has_one :comparison_report

  validate :robot_file_type
  validate :customer_file_type

  private

  def robot_file_type
    if robot_file.attached? && !robot_file.content_type.in?(%w(application/json))
      errors.add(:robot_file, 'must be a JSON file')
    end
  end

  def customer_file_type
    if customer_file.attached? && !customer_file.content_type.in?(%w(application/json))
      errors.add(:customer_file, 'must be a JSON file')
    end
  end
end
