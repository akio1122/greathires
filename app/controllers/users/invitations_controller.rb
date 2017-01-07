class Users::InvitationsController < Devise::InvitationsController
  layout "unauthenticated"

    # GET /resource/invitation/accept?invitation_token=abcdef
  def edit
    resource.invitation_token = params[:invitation_token]

    # Redirect to login page if user clicks Login in invitation email
    if params[:redirect_to_login].present?
      resource.accept_invitation!
      redirect_to new_user_session_path
    elsif params[:redirect_to_linkedinauth].present? # if Invitee clicks the 'Login with LinkedIn link'
      # put the invitation_token in session to sync with linkedin member 
      # after linkedin authentication
      session[:invitation_token] = params[:invitation_token]
      # redirect to linkedin authentication page
      redirect_to user_omniauth_authorize_path('linkedin')
    else # Accept invitation
      render :edit
    end
  end
end