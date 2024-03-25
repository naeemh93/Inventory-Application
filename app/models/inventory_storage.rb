class InventoryStorage < ApplicationRecord
  has_one_attached :robot_file
  has_one_attached :customer_file
  has_one :comparison_report
end
