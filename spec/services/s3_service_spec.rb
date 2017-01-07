require 'spec_helper'


describe S3Service do
  subject {S3Service.new}

  context "initialize" do
    it "should create a fog connection" do
      expect(subject.connection.class).to eql(Fog::Storage::AWS::Real)
    end
    it "should create a directory object" do
      expect(subject.directory.class).to eql(Fog::Storage::AWS::Directory)
    end
  end

  context "Instance Methods" do

    before do 
      subject.directory.files.create({
        key: '/test/fixtures/resume.txt',
        body: File.open(Rails.root.join("spec/fixtures/resume.txt")),
        public: false
      })
    end
  
    context "signed_url" do
      it "should return a signed url when the object is present" do
        expect(subject.signed_url('/test/fixtures/resume.txt')).
          to match(/AWSAccessKeyId\=AKIAIHQAI3SEQW3FSJ4Q\&Signature\=(\S*)\&Expires\=(\S*)/)
      end

      it "should return nil when the object is not present" do
        expect(subject.signed_url('/test/fixtures/non_existent.txt')).to eql(nil)
      end
    end

    context "destroy" do
      it "should destroy the file when the object is present" do
        expect(subject.destroy('/test/fixtures/resume.txt')).to eql(true)
        expect(subject.signed_url('/test/fixtures/resume.txt')).to eql(nil)
      end
      
      it "should return nil when the object is not present" do
        expect(subject.destroy('/test/fixtures/non_existent.txt')).to eql(nil)
      end

    end

  end
end