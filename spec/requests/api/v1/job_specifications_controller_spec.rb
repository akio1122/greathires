require "spec_helper"

describe Api::V1::JobSpecificationsController, group: :api do

  before do
    class Job < ActiveRecord::Base
      def add_default_job_manager; end
    end
    @account = FactoryGirl.create(:account1)
    @job = FactoryGirl.create :job, account_id: @account.id
    @section = FactoryGirl.create :job_specification_section, job_id: @job.id, specification_section_id: @account.specification_sections.first.id
    @job_specification = FactoryGirl.create :job_specification, job_specification_section_id: @section.id
  end

  context 'when logged in' do

    before do
      @account_manager =  FactoryGirl.create(:user_account_manager, account: @account)
      login_as @account_manager
    end

    it 'should return collection' do
      get "/api/v1/job_specifications", job_specification_section_id: @section.id
      expect(response).to be_success
      expect(json.length).to eq(1)
    end

    it 'should return job specification on show' do
      get "/api/v1/job_specifications/#{@job_specification.id}"
      expect(response).to be_success
      expect(json['id']).to eq(@job_specification.id)
    end

    it 'should not create job specification without text' do
      expect {
        post "/api/v1/job_specifications", job_specification_section_id: @section.id
        expect(response.status).to eq(422)
        expect(json).to eq({"errors"=>["Text can't be blank"]})
      }.not_to change{JobSpecification.count}
    end

    it 'should create job specification' do
      expect {
        post "/api/v1/job_specifications", job_specification_section_id: @section.id, text: Faker::Lorem.sentence
        expect(response).to be_success
      }.to change{JobSpecification.count}.by(1)
    end

    it 'should create sub job specification' do
      expect {
        post "/api/v1/job_specifications", job_specification_section_id: @section.id, parent_id: @job_specification.id, text: Faker::Lorem.sentence
        expect(response).to be_success
      }.to change{JobSpecification.count}.by(1)
    end

    it 'should destroy job specification' do
      expect {
        delete "/api/v1/job_specifications/#{@job_specification.id}"
        expect(response).to be_success
      }.to change{JobSpecification.count}.by(-1)
    end
  end

  context 'when logged out' do

    it 'should return 401 on job specifications collection' do
      get "/api/v1/job_specifications", job_specification_section_id: @section.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job specification' do
      get "/api/v1/job_specifications/#{@job_specification.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job specification' do
      post "/api/v1/job_specifications", job_specification_section_id: @section.id, text: 'Lorem ip sum'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job specification' do
      delete "/api/v1/job_specifications/#{@job_specification.id}"
      expect(response.status).to eq(401)
    end

  end

  context 'when logged in but without permission' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'should return 401 on job specifications collection' do
      get "/api/v1/job_specifications", job_specification_section_id: @section.id
      expect(response.status).to eq(401)
    end

    it 'should return 401 on show job specification' do
      get "/api/v1/job_specifications/#{@job_specification.id}"
      expect(response.status).to eq(401)
    end

    it 'should return 401 on create job specification' do
      post "/api/v1/job_specifications", job_specification_section_id: @section.id, text: 'Lorem ip sum'
      expect(response.status).to eq(401)
    end

    it 'should return 401 on destroy job specification' do
      delete "/api/v1/job_specifications/#{@job_specification.id}"
      expect(response.status).to eq(401)
    end

  end

end