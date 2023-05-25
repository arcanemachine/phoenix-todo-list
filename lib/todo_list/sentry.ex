defmodule Sentry.FinchClient do
  @moduledoc "Configure Sentry to use Finch as its HTTP client."
  @behaviour Sentry.HTTPClient

  def child_spec() do
    Supervisor.child_spec({Finch, name: __MODULE__}, id: __MODULE__)
  end

  def post(url, headers, body) do
    case :post
         |> Finch.build(url, headers, body)
         |> Finch.request(__MODULE__) do
      {:ok, %Finch.Response{status: status, headers: headers, body: body}} ->
        {:ok, status, headers, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
