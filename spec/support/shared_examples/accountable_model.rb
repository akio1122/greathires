RSpec.shared_examples "an accountable model" do
  it "includes the accountability behavior" do
    expect(subject).to be_kind_of(ARAccountability)
    expect(subject).to respond_to(:deleted_at)
  end
end
