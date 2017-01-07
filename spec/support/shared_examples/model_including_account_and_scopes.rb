RSpec.shared_examples "a model that includes Account and its scopes" do
  context "associations" do
    specify { expect(subject).to belong_to(:account) }

    it "includes the Account scopes" do
      expect(subject).to be_kind_of(AccountScopes)
    end
  end
end
