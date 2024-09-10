defmodule Projapi do
  defmodule Api do

    #função que fará o todo o processo de requisição da API
    def main( _argv ) do

      IO.puts "teste"
      CoinloreApi.obtem_moedas
      |> mostra_resultado
    end

    #função que mostra o resultado, primeira faz a verificação se ela recebeu error da função processa_resposta
    defp mostra_resultado({ :error, _ }) do
      IO.puts "ocorreu um erro"
    end

    #função que decodificara o json recebido pela api e em caso de ter recebido um erro, avisará que falhou
    defp mostra_resultado({:ok, json}) do

      #cláusula caso receba o arquivo json
      case Poison.decode(json) do
        {:ok, %{"data" => moedas}} ->
          mostra_moedas(moedas)

        #cláusula caso receba erro
        {:error, reason} ->
          IO.puts "Erro ao decodificar JSON: #{reason}"

        _ ->
          IO.puts "Formato inesperado de resposta"
      end
    end

    #
    defp mostra_moedas([]), do: IO.puts "mensagem totalmente decodificada"
    defp mostra_moedas([i | resto]) do
      name = i["name"]
      rank = i["rank"]
      price_usd = i["price_usd"]
      IO.puts "#{name} | #{rank} | #{price_usd} "
      mostra_moedas(resto)

    end

  end
end
