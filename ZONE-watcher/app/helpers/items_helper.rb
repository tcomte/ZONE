module ItemsHelper
  def getButtonForElement(item)
    @OPEN_CALAIS_URI = 'http://www.opencalais.org/Entities#'
    @WIKI_META_URI = 'http://www.wikimeta.org/Entities#'
    @INSEE_GEO_URI = 'http://rdf.insee.fr/geo/'
    @RSS_URI = 'http://purl.org/rss/1.0/'

    if(item[1] == "null")
      item[1] = "/null"
    end
    if(item[0].starts_with? @OPEN_CALAIS_URI)
      res= link_to item[0][@OPEN_CALAIS_URI.length,item[0].length], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-success"
      res+= link_to item[1], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-success"
    elsif(item[0].starts_with? @WIKI_META_URI)
      res=link_to item[0][@WIKI_META_URI.length,item[0].length], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-info"
      if(item[1].rindex('/') == nil)
        res+=link_to item[1], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-info"

      else
        res+=link_to item[1][item[1].rindex('/')+1, item[1].length], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-info"
      end
    elsif(item[0].starts_with? @INSEE_GEO_URI)
      res=link_to item[0][@INSEE_GEO_URI.length,item[0].length], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-warning"
      res+=link_to item[1][item[1].rindex('/')+1, item[1].length], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-warning"
    elsif(item[0].start_with? @RSS_URI+"source")
      res=link_to item[0][@RSS_URI.length,item[0].length], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-primary"
      res+=link_to item[1], items_path(:old => @filter,:new => {:type => item[0], :value => item[1]}), :class => "btn btn-primary"
    end
  end
end