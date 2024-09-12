
defmodule CoinloreApi do
  @url "https://api.coinlore.net/api/tickers/"

  #função que fará o todo o processo de requisição da API
  def obtem_moedas() do
    HTTPoison.get(@url)
    |> processa_resposta
  end

  #função que processará a resposta tendo como primeira cláusula o cenário em que a API retorna o status code 200.
  defp processa_resposta({ :ok, %HTTPoison.Response{status_code: 200, body: b}}) do { :ok, b}
  #Retorna "ok" mostrando que deu tudo certo e define a resposta da API como "b"
  end

  #segunda cláusula onde a requisição falhou e retorna a tupla error e r sendo r a razão do erro
  defp processa_resposta({ :error, r}), do: { :error, r}

  #terceira cláusula trata o cenário que a API responde mas a resposta é diferente do codigo 200
  defp processa_resposta({ :ok, %HTTPoison.Response{ status_code: _, body: b }}) do {:error, b}
  #também retorna error mas ao invés de r, retorna oque foi recebido pela API
  end
end
