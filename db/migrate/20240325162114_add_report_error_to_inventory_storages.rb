# frozen_string_literal: true

class AddReportErrorToInventoryStorages < ActiveRecord::Migration[7.1]
  def change
    add_column :inventory_storages, :report_error, :boolean
  end
end
