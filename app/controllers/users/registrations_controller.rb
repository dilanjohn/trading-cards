class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if resource.approved?
      super
    else
      pending_approval_path
    end
  end
end 