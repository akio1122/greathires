require "spec_helper"

describe Api::V1::JobSpecificationItemsController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
    @job_specification_section = FactoryGirl.create :job_specification_section, job_id: @job.id, specification_section_id: @account.specification_sections.first.id
  end

  context 'when logged in' do

    before do
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/job_specification_sections", job_id: @job.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return specification section on show' do
      get "/api/v1/job_specification_sections/#{@job_specification_section.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_specification_section.id)
    end

    it 'should create specification section' do
      expect {
        post "/api/v1/job_specification_sections", job_id: @job.id, specification_section_id: @account.specification_sections.last.id
        expect(response).to be_success
      }.to change{JobSpecificationSection.count}.by(1)
    end

    it 'should destroy specification section' do
      expect {
        delete "/api/v1/job_specification_sections/#{@job_specification_section.id}"
        expect(response).to be_success
      }.to change{JobSpecificationSection.count}.by(-1)
    end
  end

  context 'when logged out' do

    it 'should return 401 on specification sections collection' do
      get "/api/v1/job_specification_sections", job_id: @job.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show specification section' do
      get "/api/v1/job_specification_sections/#{@job_specification_section.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create specification section' do
      post "/api/v1/job_specification_sections", job_id: @job.id, skill_id: @account.skills.first.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy specification section' do
      delete "/api/v1/job_specification_sections/#{@job_specification_section.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on specification sections collection' do
      get "/api/v1/job_specification_sections", job_id: @job.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show specification section' do
      get "/api/v1/job_specification_sections/#{@job_specification_section.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create specification section' do
      post "/api/v1/job_specification_sections", job_id: @job.id, skill_id: @account.skills.first.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy specification section' do
      delete "/api/v1/job_specification_sections/#{@job_specification_section.id}"
      expect(response.status).to eq(401)
    end

  end

end
