defmodule Shout.Api.Surveys do
  import Shout.Client

  defstruct [
    :FromDate,
    :ToDate,
    :FirmId
  ]
  @moduledoc """
    Returns surveys sent
  """

  @doc """
  List surveys

  ## Example

    iex> client = %Shout.Client{
      auth: [{"Authorization", "Basic Y2hhcmxlc0BiaWdiYWNvbi5jb206YmlnYmFjb24="}],
      endpoint: "https://clientfeedbacktool.com/api/"
    }

    iex> client |> Shout.Api.Surveys.sent!(
      q: "FromDate: 20100101 ToDate: 20191231"
    )
  """
  def notes!(shout_client, options \\ %{"FromDate" => 20190101, "ToDate" => 20191231}) do
    opts = Enum.into(options, %{})

    get!(
      "#{shout_client.endpoint}/surveynotes?#{URI.encode_query(opts)}",
      shout_client.auth
      )
  end
  def template!(shout_client, options \\ %{"FromDate" => 20190101, "ToDate" => 20191231}) do
    opts = Enum.into(options, %{})

    get!(
      "#{shout_client.endpoint}/surveys?#{URI.encode_query(opts)}",
      shout_client.auth
      )
  end
  def sent!(shout_client, options \\ %{"FromDate" => 20190101, "ToDate" => 20191231}) do
    opts = Enum.into(options, %{})

    get!(
      "#{shout_client.endpoint}/surveyssent?#{URI.encode_query(opts)}",
      shout_client.auth
      )
      |> transform
  end

  defp transform(%Shout.Client.Response{body: %{"List" => data, "Result" => result}}) when is_list(data) do
    count = Enum.count(data)
    recipients = Enum.flat_map(data, fn s -> restructure(s) end)
    [recipients: recipients, result: result, count: count]
  end
  defp transform(%Shout.Client.Response{body: %{"Result" => result}}) do
    [result: result, count: 0]
  end

  def restructure(surveys = %{"Recipients" => recipients, "Id" => surveyId}) do

    recipients
    |> Enum.map(fn r ->
      Map.delete(surveys, "Recipients")
      |> Map.delete("Id")
      |> Map.merge(%{"SurveyId" => surveyId})
      |> Map.merge(r)
    end)
  end

end
