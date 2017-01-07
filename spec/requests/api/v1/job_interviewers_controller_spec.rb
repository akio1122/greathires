require "spec_helper"

describe Api::V1::JobInterviewersController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id

    @candidate = FactoryGirl.create :candidate, account: @account, linkedin_id: '-vqC-Cd32r'
    @job_candidate = JobCandidate.create job_id: @job.id, account_candidate_id: @candidate.id
    @user_interviewer =  FactoryGirl.create(:user_interviewer)
    @job_interviewer = FactoryGirl.create :job_interviewer, 
      {user_id: @user_interviewer.id, job_id: @job.id, job_candidate_id: @job_candidate.id,
       interview_round_id: @account.interview_rounds.first.id}
  end

  context 'when logged in' do

    before(:each) do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/job_interviewers", job_id: @job.id, job_candidate_id: @job_candidate.id

      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job interviewer' do
      get "/api/v1/job_interviewers/#{@job_interviewer.id}", job_id: @job.id

      expect(response).to be_success
    end

    it 'should not create job interviewer without user' do
      expect {
       post "/api/v1/job_interviewers", job_id: @job.id, job_candidate_id: @job_candidate.id
       expect(response.code).to eq('422')
       expect(json['errors']).to eq({"user"=>["Please pick a interviewer or check a Schedule a Break"], "interview_round"=>["can't be blank"]})
      }.not_to change{JobInterviewer.count}
    end

    it 'should create job interviewer' do
      expect {
        post "/api/v1/job_interviewers", {job_id: @job.id, job_candidate_id: @job_candidate.id, 
          user_id: @user_interviewer.id, interview_round_id: @account.interview_rounds.first.id, 
          scheduled_on: '2014-01-01 07:00 AM', length: 30}
        expect(response).to be_success
      }.to change{JobInterviewer.count}.by(1)
    end

    it 'should delete interviewer' do
      expect {
        delete "/api/v1/job_interviewers/#{@job_interviewer.id}", job_id: @job.id
      }.to change{JobInterviewer.count}.by(-1)
      expect(response).to be_success
    end

  end

  context 'when logged out' do

    it 'should return 401 on job interviewers collection' do
      get "/api/v1/job_interviewers", job_id: @job.id, job_candidate_id: @job_candidate.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show job interviewer' do
      get "/api/v1/job_interviewers/#{@job_interviewer.id}", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create job interviewer' do
      post "/api/v1/job_interviewers", job_id: @job.id, job_candidate_id: @job_candidate.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job interviewer' do
      delete "/api/v1/job_interviewers/#{@job_interviewer.id}", job_id: @job.id
      expect(response.status).to eq(401)
    end
  end

  context 'when logged in but without permission' do
  
    before(:each) do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on job interviewers collection' do
      get "/api/v1/job_interviewers", job_id: @job.id, job_candidate_id: @job_candidate.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show job interviewer' do
      get "/api/v1/job_interviewers/#{@job_interviewer.id}", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create job interviewer' do
      post "/api/v1/job_interviewers", job_id: @job.id, job_candidate_id: @job_candidate.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job interviewer' do
      delete "/api/v1/job_interviewers/#{@job_interviewer.id}", job_id: @job.id
      expect(response.status).to eq(401)
    end
  end

end