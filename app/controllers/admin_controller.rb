class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  layout 'admin'

  def dashboard
  end

  def pending_users
    @users = User.where(approved: false).order(created_at: :desc)
  end

  def whitelist
    @whitelisted_emails = WhitelistedEmail.order(created_at: :desc)
    @whitelisted_email = WhitelistedEmail.new
  end

  def approve_user
    @user = User.find(params[:id])
    @user.update(approved: true)
    redirect_to admin_pending_users_path, notice: 'User approved successfully!'
  end

  def add_to_whitelist
    @whitelisted_email = WhitelistedEmail.new(whitelist_params)
    if @whitelisted_email.save
      # Auto-approve any existing user with this email
      User.where(email: @whitelisted_email.email, approved: false)
          .update_all(approved: true)
      
      redirect_to admin_whitelist_path, notice: 'Email added to whitelist!'
    else
      @whitelisted_emails = WhitelistedEmail.order(created_at: :desc)
      render :whitelist
    end
  end

  def remove_from_whitelist
    @whitelisted_email = WhitelistedEmail.find(params[:id])
    @whitelisted_email.destroy
    redirect_to admin_whitelist_path, notice: 'Email removed from whitelist!'
  end

  private

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'Not authorized!'
    end
  end

  def whitelist_params
    params.require(:whitelisted_email).permit(:email)
  end
end 