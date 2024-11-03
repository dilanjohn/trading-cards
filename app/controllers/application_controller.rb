class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_user_approval
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end

  private

  def check_user_approval
    if user_signed_in? && !current_user.approved? && !on_allowed_path?
      sign_out current_user
      redirect_to pending_approval_path, alert: "Your account is pending approval."
    end
  end

  def on_allowed_path?
    allowed_paths = [pending_approval_path, destroy_user_session_path]
    allowed_paths.include?(request.path)
  end
end
