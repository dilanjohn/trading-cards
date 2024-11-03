module Admin
  class AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    layout 'admin'

    def dashboard
    end

    def pending_users
      @users = User.pending.order(created_at: :desc)
    end

    def rejected_users
      @users = User.rejected.order(created_at: :desc)
    end

    def whitelist
      @whitelisted_emails = WhitelistedEmail.order(created_at: :desc)
      @whitelisted_email = WhitelistedEmail.new
    end

    def approve_user
      @user = User.find(params[:id])
      @user.update(status: 'approved', approved: true)
      redirect_to admin_pending_users_path, notice: 'User approved successfully!'
    end

    def reject_user
      @user = User.find(params[:id])
      @user.update(status: 'rejected', approved: false)
      redirect_to admin_pending_users_path, notice: 'User rejected successfully!'
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

    def approved_users
      @users = User.where(approved: true).order(created_at: :desc)
    end

    def revoke_approval
      @user = User.find(params[:id])
      unless @user.admin? # Prevent revoking admin approvals
        @user.update(approved: false)
        redirect_to admin_approved_users_path, notice: 'User approval revoked successfully!'
      else
        redirect_to admin_approved_users_path, alert: "Cannot revoke approval for admin users!"
      end
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
end 