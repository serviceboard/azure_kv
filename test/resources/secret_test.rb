# frozen_string_literal: true

require_relative "../test_helper"

class SecretResourceTest < Minitest::Test
  def test_retrieve_all
    stub = stub_request("secrets", response: stub_response(fixture: "secret/retrieve_all"))
    client = AzureKV::Client.new(adapter: :test, access_token: "mybearertoken", stubs: stub)
    secrets = client.secret.retrieve_all

    assert_equal 3, secrets.length
  end

  def test_retrieve
    secret_name = "test"
    stub = stub_request("secrets/#{secret_name}", response: stub_response(fixture: "secret/retrieve"))
    client = AzureKV::Client.new(adapter: :test, access_token: "mybearertoken", stubs: stub)
    secret = client.secret.retrieve(name: secret_name)

    assert_equal AzureKV::Secret, secret.class
    assert_equal "mysecretvalue", secret.value
  end

  #   def test_create
  #     secret_name = "test"
  #     body = { value: "mysecretvalue", contentType: "token" }
  #     stub = stub_request("secrets/#{secret_name}", method: :put, body: body,
  #                         response: stub_response(fixture: "secret/create"))
  #     client = AzureKV::Client.new(adapter: :test, access_token: "mybearertoken", stubs: stub)
  #     secret = client.secret.create(name: secret_name, value: "mysecretvalue", content_type: "token")
  #
  #     assert_equal AzureKV::Secret, secret.class
  #     assert_equal "mysecretvalue", secret.value
  #   end

  #   def test_update
  #     secret_name = "test"
  #     body = { value: "mynewsecretvalue" }
  #     stub = stub_request("secrets/#{secret_name}", method: :put, body: body,
  #                          response: stub_response(fixture: "secret/update"))
  #     client = AzureKV::Client.new(adapter: :test, access_token: "mybearertoken", stubs: stub)
  #     secret = client.secret.update(name: secret_name, value: "mynewsecretvalue")
  #
  #     assert_equal AzureKV::Secret, secret.class
  #     assert_equal "mynewsecretvalue", secret.value
  #   end

  def test_delete
    secret_name = "test"
    stub = stub_request("secrets/#{secret_name}", method: :delete, response: stub_response(fixture: "secret/delete"))
    client = AzureKV::Client.new(adapter: :test, access_token: "mybearertoken", stubs: stub)
    secret = client.secret.delete(name: secret_name)

    assert_equal 1_493_938_433, secret.deletedDate
  end
end
