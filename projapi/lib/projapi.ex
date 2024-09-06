defmodule Projapi do
  @moduledoc """
  Documentation for `Projapi`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Projapi.hello()
      :world

  """
  def hello do
    :world
  end

  defmodule Api do
    @url "https://api.coinlore.net/api/tickers/?start=100&limit=100"

    def obtem_issues() do
      HTTPoison.get(@url)
      |> processa_resposta
      |> mostra_resultado

    end

    defp processa_resposta({ :ok, %HTTPoison.Response{status_code: 200, body: b}}) do { :ok, b}
    end

    defp processa_resposta({ :error, r}), do: { :error, r}
    defp processa_resposta({ :ok, %HTTPoison.Response{ status_code: _, body: b }}) do {:error, b}
    end

    defp mostra_resultado({ :error, _ }) do
      IO.puts "ocorreu um erro"
    end

    defp mostra_resultado({ :ok, json}) do
      { :ok, issues } = Poison.decode(json)
      mostra_issues(issues)
    end

    defp mostra_issues([]), do: nil
    defp mostra_issues([i | resto]) do
      name = i["name"]
      rank = i["rank"]
      price_usd = i["price_usd"]
      IO.puts "#{name} | #{rank} | #{price_usd} "
      mostra_issues(resto)

    end

  end

end
