class ExampleJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    # This is a sample job that could perform some task related to a user
    # For example, sending a welcome email, processing data, etc.
    user = User.find_by(id: user_id)
    
    if user
      # Log that the job was performed
      Rails.logger.info "ExampleJob performed for user: #{user.email}"
      
      # Example of using Redis to store some information
      $redis.set("user:#{user_id}:last_job_run", Time.current.to_i)
    end
  end
end
