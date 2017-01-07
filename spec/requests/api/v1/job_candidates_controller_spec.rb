require "spec_helper"

describe Api::V1::JobCandidatesController, group: :api do
  
  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    class Api::V1::JobCandidatesController < ApiController
      private
      def candidate linkedin_id
        AccountCandidate.find_by(linkedin_id: linkedin_id)
      end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
    @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r'
    @job_candidate = JobCandidate.create job: @job, candidate: @candidate
  end

  context 'when logged in' do
   
    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/job_candidates", job_id: @job.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job candidate on show' do
      get "/api/v1/job_candidates/#{@job_candidate.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_candidate.id)
    end

    it 'should create job candidate' do
      @job_candidate.destroy
      expect {
        post "/api/v1/job_candidates", job_id: @job.id, linkedin_id: '-vqC-Cd32r'
        expect(response).to be_success
      }.to change{JobCandidate.count}.by(1)
    end
    
    it 'should update job candidate' do
      put "/api/v1/job_candidates/#{@job_candidate.id}", candidate_status_id: nil
      expect(response).to be_success
      expect(json['id']).to eq(@job_candidate.id)
    end
    
    it 'should destroy job candidate' do
      expect {
        delete "/api/v1/job_candidates/#{@job_candidate.id}"
        expect(response).to be_success
      }.to change{JobCandidate.count}.by(-1)
    end
  end

  context 'when logged out' do
  
    it 'should return 401 on  job candidates collection' do
      get "/api/v1/job_candidates", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show job candidate' do
      get "/api/v1/job_candidates/#{@job_candidate.id}", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create job candidate' do
      post "/api/v1/job_candidates", job_id: @job.id, linkedin_id: '-vqC-Cd32r'
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on update job candidate' do
      put "/api/v1/job_candidates/#{@job_candidate.id}", candidate_status_id: nil
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on destroy job candidate' do
      delete "/api/v1/job_candidates/#{@job_candidate.id}"
      expect(response.status).to eq(401)
    end
    
  end
  
  context 'when logged in but without permission' do
  
    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end
  
    it 'should return 401 on  job candidates collection' do
      get "/api/v1/job_candidates", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show job candidate' do
      get "/api/v1/job_candidates/#{@job_candidate.id}"
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create job candidate' do
      post "/api/v1/job_candidates", job_id: @job.id, linkedin_id: '-vqC-Cd32r'
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on update job candidate' do
      put "/api/v1/job_candidates/#{@job_candidate.id}", candidate_status_id: nil
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on destroy job candidate' do
      delete "/api/v1/job_candidates/#{@job_candidate.id}"
      expect(response.status).to eq(401)
    end
  
  end

end
