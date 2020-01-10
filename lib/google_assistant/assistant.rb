# frozen_string_literal: true

require "json"
require "awesome_print"
require 'binding_of_caller'

module GoogleAssistant
  class Assistant

    attr_reader :params, :response

    def initialize(params, response)
      @params = params
      @response = response
    end

    def respond_to(&block)
      yield(self)

      response.headers["Google-Assistant-API-Version"] = "v2"

      intent.call
    end

    def intent
      @_intent ||= Intent.new(intent_string)
    end

    def arguments
      agrs = params["inputs"].first["arguments"] || []
      @_arguments ||= (agrs).map do |argument|
        Argument.from(argument)
      end
    end

    def permission_granted?
      arguments.any? do |argument|
        argument.is_a?(PermissionArgument) &&
          argument.permission_granted?
      end
    end

    def conversation
      @_conversation ||= Conversation.new(conversation_params)
    end

    def user
      @_user ||= User.new(user_params)
    end

    def device
      @_device ||= Device.new(device_params)
    end

    def tell(message, expect_user_response= true)
      response = Response::SpeechResponse.new(message)
      response.to_json(expect_user_response)
    end

    def ask(prompt, no_input_prompts = [])
      response = Response::InputPrompt.new(prompt, no_input_prompts, conversation)
      ap response
      binding.pry
      response.to_json
    end

    def ask_for_permission(context, permissions)
      response = Response::AskForPermission.new(context, permissions, conversation)
      response.to_json
    end

    private

    def inputs
      raise MissingRequestInputs if params["inputs"].nil?
      params["inputs"]
    end

    def intent_string
      intent = params["inputs"].first["intent"]
      raise MissingRequestIntent if intent.nil?
      # inputs[0]["intent"]
      intent
    end

    def conversation_params
      params["conversation"] || {}
    end

    def user_params
      params["user"] || {}
    end

    def device_params
      params["device"] || {}
    end
  end
end
