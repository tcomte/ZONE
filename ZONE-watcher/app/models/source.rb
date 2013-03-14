class Source
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  
  include ActiveModel::AttributeMethods
  require 'rubygems'
  require 'rest_client'
  $endpoint = 'http://localhost:8890/sparql/'


  attr_accessor :uri, :label, :lang, :licence, :owner, :thumb, :theme, :attrs
  attr_reader   :errors
  
  def self.all(param = "")
    query = "PREFIX SOURCE: <#{ZoneOntology::SOURCES_PREFIX}>
    SELECT *
    FROM <#{ZoneOntology::GRAPH_SOURCES}>
    WHERE {
      ?uri rdf:type <#{ZoneOntology::SOURCES_TYPE}>.
      OPTIONAL{ ?uri SOURCE:lang ?lang.}
      OPTIONAL{ ?uri SOURCE:thumbnail ?thumb.}
      OPTIONAL{ ?uri SOURCE:theme ?theme.}
      OPTIONAL{ ?uri SOURCE:owner ?owner.}
      #{param}
    }ORDER BY ?uri"#"

    store = SPARQL::Client.new($endpoint)
    sources = Array.new
    store.query(query).each do |source|
      sources << Source.find(source.uri.to_s)
    end
    return sources
  end
  
  def self.find(param)
    require 'cgi'
    require 'uri'
    
    uri = CGI.unescape(URI.escape(CGI.unescape(param)))
    
    query = "PREFIX RSS: <http://purl.org/rss/1.0/>
    SELECT ?prop ?value
    FROM <#{ZoneOntology::GRAPH_SOURCES}>
    WHERE { <#{uri}> ?prop ?value.}"
    store = SPARQL::Client.new($endpoint)
    result = store.query(query)

    source = Source.new(uri)
    result.each do |prop|
      if respond_to?("#{prop.prop.to_s.rpartition("#").last}")
        source.send("#{prop.prop.to_s.rpartition("#").last}=",prop.value.to_s)
      else
        if source.attrs == nil
          source.attrs= Array.new
        end
        source.attrs << {prop.prop.to_s => prop.value.to_s}
      end
    end
    if result.length == 0
      return nil
    end
    return source
  end

  def initialize(uri="",attributes = {})  
    @uri = uri
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
    @errors = ActiveModel::Errors.new(self)
  end
  
  def to_param
    require 'cgi'
    CGI.escape(@uri.to_s)
  end
  
  def persisted?
    false
  end 
  
  def save
uri        = "http://localhost:8890/sparql"
update_uri = "http://localhost:8890/sparql-auth"
repo       = RDF::Virtuoso::Repository.new(uri, 
                :update_uri => update_uri, 
                :username => 'dba', 
                :password => 'dba', 
                :auth_method => 'digest')
                
    graph = RDF::URI.new(ZoneOntology::GRAPH_SOURCES)
    subject = RDF::URI.new(@uri)

    res = repo.insert(RDF::Virtuoso::Query.insert_data([subject,RDF.type,RDF::URI.new(ZoneOntology::SOURCES_TYPE)]).graph(graph))
    repo.insert(RDF::Virtuoso::Query.insert_data([subject,RDF::URI.new("http://www.w3.org/2000/01/rdf-schema#label"),@label]).graph(graph)) if @label != nil
    repo.insert(RDF::Virtuoso::Query.insert_data([subject,RDF::URI.new(ZoneOntology::SOURCES_LANG),@lang]).graph(graph)) if @lang != nil 
    repo.insert(RDF::Virtuoso::Query.insert_data([subject,RDF::URI.new(ZoneOntology::SOURCES_THUMB),@thumbnail]).graph(graph)) if @thumbnail != nil 
    repo.insert(RDF::Virtuoso::Query.insert_data([subject,RDF::URI.new(ZoneOntology::SOURCES_THEME),@theme]).graph(graph)) if @theme != nil 
    repo.insert(RDF::Virtuoso::Query.insert_data([subject,RDF::URI.new(ZoneOntology::SOURCES_OWNER),@owner.to_s]).graph(graph)) if @owner != nil 
    puts attrs.to_json
    attrs.each do |attr,valStr|
      if valStr.start_with? 'http'
        val = RDF::URI.new(valStr)
      else
        val = valStr
      end
      repo.insert(RDF::Virtuoso::Query.insert_data([RDF::URI.new(@uri),RDF::URI.new(attr),val]).graph(graph))
    end
    
    return res
  end
end