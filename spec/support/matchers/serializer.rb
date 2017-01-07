RSpec::Matchers.define :have_properties do |properties|
  match do |object|
    properties.each do |property|
      actual.has_key?(property)
    end
  end
end

RSpec::Matchers.define :have_associations do |associations|
  match do |object|
    associations.each do |association|
      actual.has_key?(associations) && actual[associations].kind_of?(Array)
    end
  end
end
