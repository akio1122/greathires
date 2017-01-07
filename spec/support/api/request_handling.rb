module RequestHandling
  def json_response
    Hashie::Mash.new(JSON.parse(response.body))
  end
end

RSpec.configure do |config|
  config.include RequestHandling, type: :controller
end
