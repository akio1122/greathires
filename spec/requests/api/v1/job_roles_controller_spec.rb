require "spec_helper"

describe Api::V1::JobRolesController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
    @hiring = FactoryGirl.create(:user)
    @role = FactoryGirl.create :role_hiring_manager
    @job_role = FactoryGirl.create :job_role, job_id: @job.id, role_id: @role.id, user_id: @hiring.id

  end

  context 'when logged in' do

    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/job_roles", job_id: @job.id
      expect(response).to be_success
      expect(json.length).to eq(2)
    end

    it 'should return job role on show' do
      get "/api/v1/job_roles/#{@job_role.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_role.id)
    end

    it 'should create job role' do
      expect {
        post "/api/v1/job_roles", job_id: @job.id, role_id: @role.id, user_id: @user.id
        expect(response).to be_success
      }.to change{UserRole.count}.by(2) # as member to account
    end

    it 'should destroy job role' do
      expect {
        delete "/api/v1/job_roles/#{@job_role.id}"
        expect(response).to be_success
      }.to change{UserRole.count}.by(-1)
    end
  end

  context 'when logged out' do

    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
    end

    it 'should return 401 on job roles collection' do
      get "/api/v1/job_roles", job_id: @job.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job role' do
      get "/api/v1/job_roles/#{@job_role.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job role' do
      post "/api/v1/job_roles", job_id: @job.id, role_id: @role.id, user_id: @user.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job role' do
      delete "/api/v1/job_roles/#{@job_role.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on job roles collection' do
      get "/api/v1/job_roles", job_id: @job.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job role' do
      get "/api/v1/job_roles/#{@job_role.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job role' do
      post "/api/v1/job_roles", job_id: @job.id, job_id: @job.id, role_id: @role.id, user_id: @user.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job role' do
      delete "/api/v1/job_roles/#{@job_role.id}"
      expect(response.status).to eq(401)
    end

  end

end