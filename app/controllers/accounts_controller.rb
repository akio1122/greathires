class AccountsController < ViewController
  layout :determine_layout

  # Displays a list of accounts to manage.
  # Assume that this is only available to a system administrator
  def index
    authorize! :create_account, Account
    @accounts = Account.all.decorate

  end

  def new
    authorize! :create_account, Account
    @account = Account.new
  end

  def edit
    # Do not use current_account here because this same method could be used to edit an account from
    # a context neutral view such as the list of Accounts.
    # TODO: Re-enable in a way that supports vanity subdomain based urls: @account = Account.friendly.find(params[:id])
    @account = current_account
    authorize! :update_account, @account
    @preloaded = {
      account: AccountSerializer.new(@account, current_user: current_user, root:false),
      current_user: UserSerializer.new(current_user, root:false),
      # user_roles: RoleSerializer.new(Role.user_roles, root: false)
      user_roles: ActiveModel::ArraySerializer.new(
        Role.user_roles, each_serializer: RoleSerializer, root: false
      )
    }
  end

  def create
    authorize! :create_account, Account
    #Find first template account in system and use that as the foundation to copy.
    #TODO: In the future this create method should really take an "account to copy from" param so any account
    #      can be used as the base.
    @account = Account.create_account_from(Account.unscoped.where(is_template: true).first,
                                           params[:account].merge({owner_id: current_user.id, active: true}))
    if @account.save
      redirect_to(contextualized_account_setup_path(@account))
    else
      render :new
    end
  end

  private

  def determine_layout
    # Assume that if there's not current_account context that the system is being
    # used in an account context neutral way (administering basically)
    #TODO: Re-examine this in context of then new UX, current_account.nil? ? "administrator" : "application"
    "application"
  end

end
