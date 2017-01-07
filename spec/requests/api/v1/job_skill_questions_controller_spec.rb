require "spec_helper"

describe Api::V1::JobSkillQuestionsController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
    @user = FactoryGirl.create(:user)
    @interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
    @job_skill = JobSkill.create job_id: @job.id, skill_id: @account.skills.first.id, rating_scale_id: @account.rating_scales.first.id
    @job_skill_question = @job_skill.questions.create interview_guide_id: @interview_guide.id, user_id: @user.id, description: 'Lorem ip sum' 
  end

  context 'when logged in' do
    before do
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/job_skill_questions", job_skill_id: @job_skill.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job skill question on show' do
      get "/api/v1/job_skill_questions/#{@job_skill_question.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_skill_question.id)
    end

    it 'should not create job skill question without description' do
      interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
      expect {
        post "/api/v1/job_skill_questions", interview_guide_id: interview_guide.id, user_id: @user.id, job_skill_id: @job_skill.id
        expect(response.status).to eq(422)
        expect(json).to eq({"errors"=>["Description can't be blank"]})
      }.not_to change{JobSkillQuestion.count}
    end

    it 'should create job skill question' do
      interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
      expect {
        post "/api/v1/job_skill_questions", interview_guide_id: interview_guide.id, user_id: @user.id, job_skill_id: @job_skill.id, description: 'Foo bar' 
        expect(response).to be_success
      }.to change{JobSkillQuestion.count}.by(1)
    end

    it 'should destroy job skill question' do
      expect {
        delete "/api/v1/job_skill_questions/#{@job_skill_question.id}"
        expect(response).to be_success
      }.to change{JobSkillQuestion.count}.by(-1)
    end
  end

  context 'when logged out' do

    it 'should return 401 on job skill questions collection' do
      get "/api/v1/job_skill_questions", job_skill_id: @job_skill.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job skill question' do
      get "/api/v1/job_skill_questions/#{@job_skill_question.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job skill question' do
      interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
      post "/api/v1/job_skill_questions", interview_guide_id: interview_guide.id, user_id: @user.id, job_skill_id: @job_skill.id, description: 'Foo bar' 
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job skill question' do
      delete "/api/v1/job_skill_questions/#{@job_skill_question.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      login_as @user
    end

    it 'should return 401 on job skill questions collection' do
      get "/api/v1/job_skill_questions", job_skill_id: @job_skill.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job skill question' do
      get "/api/v1/job_skill_questions/#{@job_skill_question.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job skill question' do
      interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
      post "/api/v1/job_skill_questions", interview_guide_id: interview_guide.id, user_id: @user.id, job_skill_id: @job_skill.id, description: 'Foo bar' 
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job skill question' do
      delete "/api/v1/job_skill_questions/#{@job_skill_question.id}"
      expect(response.status).to eq(401)
    end

  end

end