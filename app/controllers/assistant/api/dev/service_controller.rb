require_dependency "assistant/application_controller"

module Assistant
  class Api::Dev::ServiceController < ApplicationController
    skip_before_action :verify_authenticity_token


    def conversation
      assistant_response = GoogleAssistant.respond_to(params, response) do |assistant|
        if !assistant.arguments.present?
          assistant.intent.main do
            assistant.tell("<speak>Welcome to It is easy Assistant</speak>")
          end
        else
          assistant.intent.text do
            assistant.ask(
              prompt: "<speak>Hi there! Say something, please.</speak>",
              no_input_prompt: [
                "<speak>If you said something, I didn't hear you.</speak>",
                "<speak>Did you say something?</speak>"
              ]
            )
          end
        end


      end


      render json: assistant_response

      # render json: {
      #       "payload": {
      #         "google": {
      #           "expectUserResponse": true,
      #           "richResponse": {
      #             "items": [
      #               {
      #                 "simpleResponse": {
      #                   "textToSpeech": "Here's an example of a simple response. Which type of response would you like to see next?",
      #                   "displayText": "Here's a simple response. Which response would you like to see next?"
      #                 }
      #               }
      #             ]
      #           }
      #         }
      #       }
      #     }
    end

  end
end
