class Search < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
  has_many :sources, class_name: "SearchSource"
  has_many :filters, class_name: "SearchFilter"

  def self.build_from_form(params)
    result = Search.new
    sourcesJson = JSON.parse params[:sources]
    sourcesJson.each do |kind,vals|
      vals.each do |value|
        result.sources << SearchSource.build_from_form(CGI.unescape(value),kind)
      end
    end

    filtersJson = JSON.parse params[:filters]
    filtersJson.each do |kind,vals|
      vals.each do |value|
        result.filters << SearchFilter.build_from_form(CGI.unescape(value),kind)
      end
    end

    return result
  end

  def getItemsNumber
    #TODO
    #request = generateFilterSPARQLRequest(filters)
    #query = "SELECT ?number COUNT(DISTINCT ?concept) FROM <#{ZoneOntology::GRAPH_ITEMS}> WHERE {\n"
    #query += request
    #query += "?concept <http://purl.org/rss/1.0/title> ?title.} LIMIT 1"
    #puts query
    #store = SPARQL::Client.new($endpoint)
    #if store.query(query).length == 0
    #  return 0
    #else
    #  return store.query(query)[0]["callret-1"]
    #end
    return 0
  end

  def generateSPARQLRequest
    extendQuery = ""
    self.sources.each do |source|
      extendQuery += "#{source.getSparqlTriple}. \n"
    end
    self.filters.each do |filter|
      if filter.kind == "and"
        extendQuery += "#{filter.getSparqlTriple}. \n"
       end
      #TODO
    end
    extendQuery
  end
end
