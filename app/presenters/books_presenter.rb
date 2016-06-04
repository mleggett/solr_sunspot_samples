class BooksPresenter < Struct.new(:query, :books)

  def initialize(params)
    params = params.with_indifferent_access
    query = params["query"]
    genre_ids = (params.try(:[], "genre_ids") || []).map(&:to_i)
    search_from, search_to = params.try(:[], "from"), params.try(:[], "to"))

    self.query = {
			page: params[:page] || 1,
			from: search_from,
			to: search_to,
			genre_ids: genre_ids,
      query: query
    }

    search_results = Sunspot.search(Book) do
      with :filter_date, search_from..(search_to + 1.day)
      paginate page: params[:page], per_page: 10
      order_by :filter_date, "desc"
      with(:genres).any_of(genre_ids) if genre_ids.present?
      adjust_solr_params { |params| params[:q] = query }
      facet :genre_ids
    end
    self.books = search_results.results || []
  end

end
