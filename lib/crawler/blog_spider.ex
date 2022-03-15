defmodule BlogSpider do
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url(), do: "https://ezphimmoi.net"

  @impl Crawly.Spider
  def init(), do:
    [
      start_urls: [
        "https://ezphimmoi.net/category/hoat-hinh/"
      ]
    ]

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    pages =
      document
        |> Floki.find(".page-navigation .pagination a")
        |> Enum.map(&Floki.text/1)
        |> Enum.filter(fn num -> Integer.parse(num) != :error end)
        |> Enum.map(fn num -> String.to_integer(to_string(num)) end)

    max_page = Enum.max(pages)
    IO.inspect(max_page)

    items =
      document
        |> Floki.find(".movie-list-index .movie-item")
        |> Enum.map(&Floki.text/1)
        |> Enum.map(fn title ->  %{title: title} end)

    IO.inspect(items)

    requests =
      (for x <- 2..max_page, do: build_absolute_url("category/hoat-hinh/page/#{x}/"))
        |> Enum.uniq()
        |> Enum.map(&Crawly.Utils.request_from_url/1)

    IO.inspect(requests)

    %Crawly.ParsedItem{items: items, requests: requests}
  end

  defp build_absolute_url(url), do: URI.merge(base_url(), url) |> to_string()
end
