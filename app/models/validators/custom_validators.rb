module CustomValidators
  class AssociatedStatus < ActiveModel::Validator
    def validate(record)
      unless Status.exists?(account_id: record.account_id, id: record.status_id)
         record.errors[:status_id] << "not from current account"
      end
    end
  end

end