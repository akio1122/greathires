RSpec.shared_examples "a serializer" do
  it "includes the ID" do
    expect(subject).to have_key(:id)
  end

  it "includes timestamps" do
    [:created_at, :updated_at, :created_at_user, :updated_at_user].each do |attr|
      expect(subject).to have_key(attr)
    end
  end
end

RSpec.shared_examples "a serializer that includes important properties" do
  it "includes important properties" do
    expect(subject).to have_properties(properties)
  end
end

RSpec.shared_examples "a serializer that includes associations" do
  it "includes associations" do
    expect(subject).to have_associations(associations)
  end
end
