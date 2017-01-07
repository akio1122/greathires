require "spec_helper"

describe Api::V1::JobsController, group: :api do
  
  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
  end

  context 'when logged in' do

    before(:each) do
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/jobs", account_id: @account.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job on show' do
      get "/api/v1/jobs/#{@job.id}"
      expect(response).to be_success
      expect(json['name']).to eq(@job.name)
    end

    it 'should not create job without function, level and position' do
      expect {
        post "/api/v1/jobs", account_id: @account.id, function_id: @account.functions.first.id,
              level_id: @account.levels.first.id, position_id: @account.positions.first.id
        expect(response.status).to eq(422)
      }.not_to change{Job.count}
    end

    it 'should create job' do
      expect {
        post "/api/v1/jobs", name: "Lorem", requisition_ref: "Dolor", account_id: @account.id, function_id: @account.functions.first.id,
              level_id: @account.levels.first.id, position_id: @account.positions.first.id
        expect(response).to be_success
      }.to change{Job.count}.by(1)
    end

  end

  context 'when logged out' do
    
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it 'should return 401 on jobs collection' do
      get "/api/v1/jobs", account_id: @account.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job' do
      get "/api/v1/jobs/#{@job.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job' do
      post "/api/v1/jobs", account_id: @account.id
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on jobs collection' do
      get "/api/v1/jobs", account_id: @account.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job' do
      get "/api/v1/jobs/#{@job.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job' do
      post "/api/v1/jobs", account_id: @account.id
      expect(response.status).to eq(401)
    end

  end

end