defmodule Shout.Api.Followup do
  import Shout.Client
  def comments!(shout_client, options \\ %{"FromDate" => 20190101, "ToDate" => 20191231}) do
    opts = Enum.into(options, %{})

    get!(
      "#{shout_client.endpoint}/followupcomments?#{URI.encode_query(opts)}",
      shout_client.auth
      )
  end

end
