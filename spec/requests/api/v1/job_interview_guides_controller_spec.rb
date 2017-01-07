require "spec_helper"

describe Api::V1::JobInterviewGuidesController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
    @job_interview_guide = FactoryGirl.create :job_interview_guide, job_id: @job.id
  end

  context 'when logged in' do
   
    before do
      @user =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @user
    end

    it 'should return collection' do
      get "/api/v1/job_interview_guides", job_id: @job.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job interview giude on show' do
      get "/api/v1/job_interview_guides/#{@job_interview_guide.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_interview_guide.id)
    end

    it 'should create job interview giude' do
      expect {
        post "/api/v1/job_interview_guides", job_id: @job.id, num: '1'
        expect(response).to be_success
      }.to change{JobInterviewGuide.count}.by(1)
    end
  
    it 'should destroy job interview giude' do
      expect {
        delete "/api/v1/job_interview_guides/#{@job_interview_guide.id}"
        expect(response).to be_success
      }.to change{JobInterviewGuide.count}.by(-1)
    end
  end

  context 'when logged out' do

    it 'should return 401 on  job interview giudes collection' do
      get "/api/v1/job_interview_guides", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show job interview giude' do
      get "/api/v1/job_interview_guides/#{@job_interview_guide.id}", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create job interview giude' do
      post "/api/v1/job_interview_guides", job_id: @job.id, num: '2'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job interview giude' do
      delete "/api/v1/job_interview_guides/#{@job_interview_guide.id}"
      expect(response.status).to eq(401)
    end
    
  end
  
  context 'when logged in but without permission' do
  
    before do
      @user =  FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on  job interview giudes collection' do
      get "/api/v1/job_interview_guides", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on show job interview giude' do
      get "/api/v1/job_interview_guides/#{@job_interview_guide.id}", job_id: @job.id
      expect(response.status).to eq(401)
    end
  
    it 'should return 401 on create job interview giude' do
      post "/api/v1/job_interview_guides", job_id: @job.id, num: '2'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job interview giude' do
      delete "/api/v1/job_interview_guides/#{@job_interview_guide.id}"
      expect(response.status).to eq(401)
    end
  
  end

end