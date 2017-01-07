class Users::RegistrationsController < Devise::RegistrationsController
  layout "application", only: :edit
 
  def create
    super
    # If registration started as a LinkedIn Auth, be sure to carry the auth token forward
    # so it can be used in future LinkedIn calls.
    session["devise.linkedin_authtoken"] = request.env['omniauth.auth'].credentials.token || nil
  end

  def update
    @user = User.find(current_user.id)
    if params[:user][:password] != params[:user][:password_confirmation]
      @user.errors[:password] = "Passwords don't match"
      render "edit"
    else
      account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

      # required for settings form to submit when password is left blank
      if account_update_params[:password].blank?
        account_update_params.delete("password")
        account_update_params.delete("password_confirmation")
      end

      @user = User.find(current_user.id)
      if @user.update_attributes(account_update_params)
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true
        redirect_to after_update_path_for(@user)
      else
        render "edit"
      end

    end
  end
  
end
