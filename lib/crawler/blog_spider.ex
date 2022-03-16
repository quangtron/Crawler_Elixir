defmodule BlogSpider do
  @base_url "https://ezphimmoi.net/category/hoat-hinh/"

  @doc """
  Fetch first data
  """
  def fetch_data_head(), do: Crawly.fetch(@base_url)

  @doc """
  Fetch data from page 2 on the website
  """
  def fetch_tail_body_data(page_number \\ 2) do
    with {:ok, data} <- Floki.parse_document(Crawly.fetch("#{@base_url}page/#{page_number}/").body),
    true <- check_page_has_film(data) > 0 do
      data ++ fetch_tail_body_data(page_number + 1)
    else
      :error -> []
      _ -> []
    end
  end

  @doc """
  Check page has film
  """
  def check_page_has_film(docs), do: docs |> Floki.find(".movie-list-index") |> length()

  @doc """
  Get list film title
  """
  def get_film_info_list(docs) do
    docs
      |> Floki.find(".movie-list-index .movie-item")
      |> Enum.map(fn x -> %{
        link: Floki.attribute(x, "href") |> Enum.at(0),
        title: String.replace(Floki.text(x), "\t", "-"),
        full_series:
          Floki.find(x, ".block-wrapper .movie-meta .ribbon")
            |> Floki.text()
            |> String.downcase()
            |> String.contains?("full"),
        number_of_episode:
          Floki.find(x, ".block-wrapper .movie-meta .ribbon")
            |> Floki.text()
            |> String.split("/")
            |> Enum.map(fn x -> "0" <> String.replace(x, ~r/[^\d]/, "") end)
            |> List.last()
            |> String.to_integer(),
        thumnail:
          Floki.find(x, ".block-wrapper .movie-thumbnail .public-film-item-thumb")
            |> Floki.attribute("data-wpfc-original-src")
            |> Enum.at(0),
        year:
          Floki.find(x, ".block-wrapper .movie-meta .movie-title-2")
            |> Floki.text()
            |> String.replace(~r/[^\d]/, "")
            |> String.to_integer(),
      } end)
  end

  @doc """
  Format response data
  """
  def convert_data(items, header) do
    {_, date} = Enum.at(header, 0)
    %{
      crawled_at: date,
      total: length(items),
      items: items
    }
  end

  def main() do
    head_data = fetch_data_head()
    header = head_data.headers
    {:ok, head_body_data} = Floki.parse_document(head_data.body)
    items = head_body_data ++ fetch_tail_body_data(38) |> get_film_info_list()
    IO.inspect(length(items))

    File.write("./priv/output/output.json", JSON.encode!(convert_data(items, header)))
  end
end
