class OmniauthController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :steam

  def steam
    @user = User.create_from_provider_data(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Steam") if is_navigational_format?
    else
      set_flash_message(:alert, @user.errors.full_messages) if is_navigational_format?
      redirect_to new_user_session_path
    end
  end

  def failure
    redirect_to new_user_session_path
  end
end
