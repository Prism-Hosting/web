class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  helper_method :current_context
  def current_context
  end
end
