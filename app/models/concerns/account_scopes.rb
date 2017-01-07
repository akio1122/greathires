module AccountScopes
  extend ActiveSupport::Concern
  included do
    scope :by_account, -> account_id { where(account_id: account_id)}
    scope :active, -> {where(active: true)}
    scope :inactive, -> {where(active: false)}
    # Scope allows for "previewing" of objects by the author before release.
    scope :active_for_user, ->(user_id) {where("active = ? or created_by = ?", true, user_id)}  
  end
end