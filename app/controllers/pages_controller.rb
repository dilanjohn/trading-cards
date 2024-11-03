class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  
  def pending_approval
  end
end 