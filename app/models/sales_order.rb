class SalesOrder < LedgerBuddyModel

    attribute :visible_id, :customer_id

    # health_check_id, :deployment_id, :log, :error_message, :status, :duration, :created_at_to_now
    # attribute :user_id

    self.member_url     = "sales_orders/:id"
#   self.collection_url = "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/check_runs"

    has_many :lines, :class_name=>'SoLine' # belongs_to :health_check


end
