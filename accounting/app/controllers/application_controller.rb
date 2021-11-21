class ApplicationController < ActionController::Base
  before_action :check_authorization
  helper_method :current_account

  def current_account
    return if session[:account_id].blank?

    @_current_account ||= Account.find(session[:account_id])
  end

  def check_authorization
    return unless session[:account_id].blank?

    redirect_to sessions_path
  end
end
