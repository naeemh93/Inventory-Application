module LocationHelper
  def report_state(inventory_storage)
    return '-' unless inventory_storage.customer_file.attached?

    comparison_report = inventory_storage.comparison_report

    # Return if there's no comparison report
    return '-' unless comparison_report.present?

    # Check the status of the comparison report
    case comparison_report.status
    when "failed"
      'Issue with comparison file'
    else
      # If report file is attached, provide a link; otherwise, indicate readiness
      comparison_report.report_file.attached? ? link_to('View Report', rails_blob_path(comparison_report.report_file, disposition: "attachment")) : 'File is getting ready'
    end
  end
end
