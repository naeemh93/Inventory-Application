# frozen_string_literal: true

class CreateComparisonReports < ActiveRecord::Migration[7.1]
  def change
    create_table :comparison_reports do |t|
      t.references :inventory_storage, null: false, foreign_key: true
      t.string :status
      t.timestamps
    end
  end
end
