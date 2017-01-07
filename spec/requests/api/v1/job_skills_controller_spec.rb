require "spec_helper"

describe Api::V1::JobSkillsController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
    @job_skill = JobSkill.create job_id: @job.id, skill_id: @account.skills.first.id, rating_scale_id: @account.rating_scales.first.id
  end

  context 'when logged in' do

    before do
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/job_skills", job_id: @job.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job skill on show' do
      get "/api/v1/job_skills/#{@job_skill.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_skill.id)
    end

    it 'should create job skill' do
      expect {
        post "/api/v1/job_skills", job_id: @job.id, skill_id: @account.skills.first.id
        expect(response).to be_success
      }.to change{JobSkill.count}.by(1)
    end

    it 'should destroy job skill' do
      expect {
        delete "/api/v1/job_skills/#{@job_skill.id}"
        expect(response).to be_success
      }.to change{JobSkill.count}.by(-1)
    end
  end

  context 'when logged out' do

    it 'should return 401 on job skills collection' do
      get "/api/v1/job_skills", job_id: @job.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job skill' do
      get "/api/v1/job_skills/#{@job_skill.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job skill' do
      post "/api/v1/job_skills", job_id: @job.id, skill_id: @account.skills.first.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job skill' do
      delete "/api/v1/job_skills/#{@job_skill.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on job skills collection' do
      get "/api/v1/job_skills", job_id: @job.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job skill' do
      get "/api/v1/job_skills/#{@job_skill.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job skill' do
      post "/api/v1/job_skills", job_id: @job.id, skill_id: @account.skills.first.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job skill' do
      delete "/api/v1/job_skills/#{@job_skill.id}"
      expect(response.status).to eq(401)
    end

  end

end