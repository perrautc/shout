defmodule Shout.Client.Response do
  @moduledoc """
    Struct which represents CFT API response
  """

  defstruct [
    :request,
    :body,
    :headers,
    :status
  ]
end
