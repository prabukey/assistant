# frozen_string_literal: true

Dir["#{File.dirname(__FILE__)}/google_assistant/**/*.rb"].each { |file| require file }

module GoogleAssistant

  def self.respond_to(params, response, &block)
    { "payload" => { "google" => Assistant.new(params["originalDetectIntentRequest"]["payload"], response).respond_to(&block) } }

  end
end
