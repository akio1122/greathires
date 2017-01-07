require "spec_helper"

describe Api::V1::JobSpecificationQuestionsController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
  end

  context 'when logged in' do

    before do
      @user = FactoryGirl.create(:user)
      @section = FactoryGirl.create :job_specification_section, job_id: @job.id, specification_section_id: @account.specification_sections.first.id
      @interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
      @job_specification_question = FactoryGirl.create :job_specification_question, section_id: @section.id, user_id: @user.id, interview_guide_id: @interview_guide.id
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/job_specification_section_questions", section_id: @section.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job specification question on show' do
      get "/api/v1/job_specification_section_questions/#{@job_specification_question.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_specification_question.id)
    end

    it 'should not create job specification question without description' do
      expect {
        post "/api/v1/job_specification_section_questions", section_id: @section.id, user_id: @user.id, interview_guide_id: @interview_guide.id
        expect(response.status).to eq(422)
        expect(json).to eq({"errors"=>["Description can't be blank"]})
      }.not_to change{JobSpecificationSectionQuestion.count}
    end

    it 'should create job specification question' do
      expect {
        post "/api/v1/job_specification_section_questions", section_id: @section.id, description: Faker::Lorem.sentence, user_id: @user.id, interview_guide_id: @interview_guide.id
        expect(response).to be_success
      }.to change{JobSpecificationSectionQuestion.count}.by(1)
    end

    it 'should destroy job specification question' do
      expect {
        delete "/api/v1/job_specification_section_questions/#{@job_specification_question.id}"
        expect(response).to be_success
      }.to change{JobSpecificationSectionQuestion.count}.by(-1)
    end
  end

  context 'when logged out' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
      @section = FactoryGirl.create :job_specification_section, job_id: @job.id, specification_section_id: @account.specification_sections.first.id
      @job_specification_question = FactoryGirl.create :job_specification_question, section_id: @section.id
    end

    it 'should return 401 on job specification questions collection' do
      get "/api/v1/job_specification_section_questions", section_id: @section.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job specification question' do
      get "/api/v1/job_specification_section_questions/#{@job_specification_question.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job specification question' do
      post "/api/v1/job_specification_section_questions", section_id: @section.id, description: 'Lorem ip sum', user_id: @user.id, interview_guide_id: @interview_guide.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job specification question' do
      delete "/api/v1/job_specification_section_questions/#{@job_specification_question.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @interview_guide = FactoryGirl.create(:job_interview_guide, job_id: @job.id)
      @section = FactoryGirl.create :job_specification_section, job_id: @job.id, specification_section_id: @account.specification_sections.first.id
      @job_specification_question = FactoryGirl.create :job_specification_question, section_id: @section.id
      login_as @user
    end

    it 'should return 401 on job specification questions collection' do
      get "/api/v1/job_specification_section_questions", section_id: @section.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job specification question' do
      get "/api/v1/job_specification_section_questions/#{@job_specification_question.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job specification question' do
      post "/api/v1/job_specification_section_questions", section_id: @section.id, description: 'Lorem ip sum', user_id: @user.id, interview_guide_id: @interview_guide.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job specification question' do
      delete "/api/v1/job_specification_section_questions/#{@job_specification_question.id}"
      expect(response.status).to eq(401)
    end

  end

end
