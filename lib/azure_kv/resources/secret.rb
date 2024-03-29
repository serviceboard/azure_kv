# frozen_string_literal: true

module AzureKV
  # Secret resource class
  class SecretResource < Resource
    def retrieve_all
      AzureKV.logger.info "Retrieving secrets"

      url = "secrets"
      next_page = true
      secrets = []

      while next_page
        response = get_request(url).body

        data = response["value"]
        next_link = response["nextLink"]

        data.each { |secret| secrets << Secret.new(secret) }

        if next_link.nil? || next_link == "null"
          next_page = false
        else
          url = "secrets?#{next_link.split("?")[1]}"
        end
      end

      secrets
    end

    def create(name:, value:, content_type:, **attributes)
      AzureKV.logger.info "Creating secret #{name}"

      body = attributes.merge({ contentType: content_type, value: value }).compact
      Secret.new put_request("secrets/#{name}", body).body
    end

    def update(name:, value:)
      AzureKV.logger.info "Updating secret #{name}"

      body = { value: value }
      Secret.new put_request("secrets/#{name}", body).body if retrieve(name: name)
    end

    def retrieve(name:)
      AzureKV.logger.info "Retrieving secret #{name}"

      Secret.new get_request("secrets/#{name}").body
    end

    def delete(name:)
      AzureKV.logger.info "Deleting secret #{name}"

      Object.new delete_request("secrets/#{name}").body
    end
  end
end
