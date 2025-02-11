module UserLogging
  extend ActiveSupport::Concern

  included do
    before_action :log_current_user
  end

  private

  def log_current_user
    Rails.logger.debug "Current User: #{current_user&.email} (ID: #{current_user&.id})"
  end
end