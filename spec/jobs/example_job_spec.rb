require 'rails_helper'

RSpec.describe ExampleJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }

  it 'queues the job' do
    expect {
      ExampleJob.perform_later(user.id)
    }.to have_enqueued_job(ExampleJob)
      .with(user.id)
      .on_queue('default')
  end

  it 'executes perform' do
    # Mock Redis to avoid actual Redis calls during tests
    redis_double = double('redis')
    allow($redis).to receive(:set).and_return(true)
    allow(Rails.logger).to receive(:info)

    # Perform the job
    perform_enqueued_jobs do
      ExampleJob.perform_later(user.id)
    end

    # Verify logger was called with expected message
    expect(Rails.logger).to have_received(:info).with("ExampleJob performed for user: #{user.email}")
  end

  it 'handles non-existent users gracefully' do
    non_existent_id = 999999
    
    # Ensure no error is raised
    expect {
      perform_enqueued_jobs do
        ExampleJob.perform_later(non_existent_id)
      end
    }.not_to raise_error
  end
end
