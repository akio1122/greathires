module ARAccountability
  # ARAccountability Concern adds functions that help the applicaiton keep track of who is doing what
  # to various model objects.  This is a standard need for SAAS type applications.
  
  extend ActiveSupport::Concern

  
  included do
    acts_as_paranoid
    include ActiveModel::Validations   
    
    # SentientUser gem allows us to make 'current_user' available to the model object.
    # Callbacks added to user stamp records up on create and update.
    include SentientUser
    before_save :stamp_updated_by
    before_create :stamp_created_by, :stamp_updated_by
    
    private
      # ActiveSupport's presence method required to aleviate migration complaints
      def stamp_created_by
        self.created_by = self.class.current.presence ? self.class.current.id : nil
      end
      
      def stamp_updated_by
        self.updated_by = self.class.current.presence ? self.class.current.id : nil
      end
      
  end
end

# The method below is NOT used to include this concern's functionality
# due to problems with migrations and SentientUser in the fact that
# class.current.id seems to be needing to be available in a migration but it can't be.
#ActiveRecord::Base.send(:include, UserStamping)