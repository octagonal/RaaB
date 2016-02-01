require 'redd'
require 'rdiscount'
require 'htmlentities'
require 'yaml'
require './repository/Api.rb'

class Info < Api
  def Info.getSidebar()
    md = RDiscount.new( HTMLEntities.new.decode(@@sub.description))
    html = Nokogiri::HTML(md.to_html)

    links = html.xpath("//ul/li//a").map { |b|
      {
        :title => b.text,
        :link => b.attribute("href").text
      }
    }.each { |link|
      link[:link] = link[:link].split("/").select {|n| n != ""}
      link[:link] = link[:link][link[:link].length - 2 .. link[:link].length - 1].join("/")
    }

    sidebar = {
      :title => html.xpath("//p")[0].text,
      :description => html.xpath("//p")[1].text,
      :links => links
    }
    puts sidebar
    sidebar
  end
end
