defmodule Shout.Client do
  @moduledoc """
    Struct which represents CFT client
  """
  defstruct [
    auth: nil,
    endpoint: "https://clientfeedbacktool.com/api"
  ]

  def from_json!(map) do
    json_library().decode!(map)
  end
  def get!(url, headers) do
    request = %{url: url, headers: headers}
    response = HTTPoison.get!(url, headers, [recv_timeout: 50_000])

    %Shout.Client.Response{
      request: request,
      body: from_json!(response.body),
      headers: response.headers,
      status: response.status_code
    }
  end

  def surveyssent(client, url \\ "surveyssent") do
    headers = client.auth
    url = "#{client.endpoint}/#{url}"

    get!(url, headers)
  end
  def new(credentials = %{username: _, password: _}) do
    auth = authorization_header(credentials, [])
    %__MODULE__{auth: auth}
  end
  def authorization_header(%{username: user, password: password}, headers) do
    userpass = "#{user}:#{password}"
    headers ++ [{"Authorization", "Basic #{:base64.encode(userpass)}"}]
  end
  defp json_library do
    Application.get_env(Shout.Client, :json_library) || Jason
  end
end
