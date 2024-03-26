# frozen_string_literal: true

module LocationHelper
  def report_state(inventory_storage)
    return '-' unless inventory_storage.customer_file.attached?

    comparison_report = inventory_storage.comparison_report

    # Return if there's no comparison report
    return '-' unless comparison_report.present?

    # Check the status of the comparison report
    case comparison_report.status
    when 'failed'
      'Report Generation Failed'
    else

      if comparison_report.report_file.attached?
        link_to('Download Report',
                rails_blob_path(comparison_report.report_file,
                                disposition: 'attachment'))
      else
        'Report is getting ready'
      end
    end
  end
end
