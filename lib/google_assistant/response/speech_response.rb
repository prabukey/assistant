# frozen_string_literal: true

require "google_assistant/response/base"

module GoogleAssistant
  module Response
    class SpeechResponse < Base

      attr_accessor :message

      def initialize(message)
        @message = message
        super()
      end

      def to_json(expect_user_response)
        raise GoogleAssistant::InvalidMessage if message.nil? || message.empty?

        response = super(expect_user_response)

        speech_response = if is_ssml?(message)
          { ssml: message }
        else
          { textToSpeech: message }
        end
        response[:richResponse] = { items: [{simpleResponse: speech_response}] }
        return response
      end
    end
  end
end
