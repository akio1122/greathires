module ApiAuthentication
  def any_account
    @any_account ||= FactoryGirl.create(:account)
  end

  def any_user
    @any_user ||= FactoryGirl.build(:user_account_manager, account: any_account)
    Role.instance_variable_set(:@account_manager, @any_user) # TODO: revisit
    @any_user.save!
    @any_user
  end
end

RSpec.configure do |config|
  config.include ApiAuthentication, authenticated: true

  config.before(authenticated: true) do
    sign_in any_user
  end
end
