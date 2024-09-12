defmodule Projapi do
  defmodule Api do
    # Função que faz a requisição da API e depois exibe a lista de moedas e os detalhes da moeda com base no rank fornecido
    def main([rank_str]) do
      rank = String.to_integer(rank_str)  # Convertendo o argumento de rank para número
      CoinloreApi.obtem_moedas()
      |> mostra_resultado(rank)
    end

    # Função que mostra o resultado, verificando se houve erro na resposta da API
    defp mostra_resultado({:error, _}, _rank) do
      IO.puts "Ocorreu um erro"
    end

    # Função que decodifica o JSON recebido da API
    defp mostra_resultado({:ok, json}, rank) do
      case Poison.decode(json) do
        {:ok, %{"data" => moedas}} ->
          # Exibe a lista completa de moedas
          mostra_moedas(moedas)
          IO.puts "Agora exibindo os detalhes da moeda de rank #{rank}:"
          # Exibe os detalhes da moeda com o rank fornecido
          mostra_moeda_por_rank(moedas, rank)

        {:error, reason} ->
          IO.puts "Erro ao decodificar JSON: #{reason}"

        _ ->
          IO.puts "Formato inesperado de resposta"
      end
    end

    # Função para exibir todas as moedas
    defp mostra_moedas([]), do: IO.puts "Abaixo listaremos os detalhes da moeda selecionada"
    defp mostra_moedas([i | resto]) do
      name = i["name"]
      rank = i["rank"]
      price_usd = i["price_usd"]
      IO.puts "#{rank} | #{name} | #{price_usd}"
      mostra_moedas(resto)
    end

    # Função para exibir detalhes de uma moeda específica pelo rank
    defp mostra_moeda_por_rank(moedas, rank) do
      case encontra_moeda(moedas, rank) do
        nil ->
          IO.puts "Nenhuma moeda encontrada com o rank #{rank}."
        moeda ->
          IO.puts "Detalhes da moeda #{moeda["name"]}:"
          IO.puts "Rank: #{moeda["rank"]}"
          IO.puts "Preço em USD: #{moeda["price_usd"]}"
          IO.puts "Capitalização de mercado: #{moeda["market_cap_usd"]}"
          IO.puts "Volume de 24h: #{moeda["volume24"]}"
      end
    end

    # Função recursiva para encontrar a moeda com o rank especificado
    defp encontra_moeda([], _rank), do: nil
    defp encontra_moeda([moeda | resto], rank) do
      if moeda["rank"] == rank do
        moeda
      else
        encontra_moeda(resto, rank)
      end

    end


  end
end
