module SerializerExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :serializer

    let(:attributes)     { {} }
    let(:resource_name)  { described_class.name.underscore[0..-12].to_sym }
    let(:resource_class) { resource_name.to_s.classify.safe_constantize }

    let(:resource) do
      klazz = resource_class || Object.new
      klazz.new.tap do |res|
        allow(res).to receive(:cache_key)
        allow(res).to receive(:attributes) { attributes }
        allow(res).to receive(:read_attribute_for_serialization) { |name| attributes[name] }
      end
    end

    let(:serializer) { described_class.new(resource) }

    subject { serializer.serializable_hash.with_indifferent_access }
  end

  RSpec.configure do |config|
    config.include self, type: :serializer, file_path: %r{spec/serializers}
  end
end
