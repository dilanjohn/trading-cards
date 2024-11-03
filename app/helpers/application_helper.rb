module ApplicationHelper
  def pending_users_count
    User.where(status: 'pending').count
  end
end
