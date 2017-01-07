module AccountApiScopes
  extend ActiveSupport::Concern
  included do
    # NOTE: Most Account-related API controllers suppport all these methods
    # since most account objects have active status and directly belong to an account.
    # It is rare and ok that some do not support these.
    has_scope :by_account, as: :account_id, only: [:index] 
    has_scope :active_for_user, if: !:active, only: [:index]
    has_scope :active, as: :active, default: false,  only: [:index]  do |controlller, scope, value|
      value == "all" ? scope : value.to_bool ? scope.active : scope.inactive
    end
  
    private
     
  
  end
end

