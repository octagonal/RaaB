class Api
  @@NAV_PAGES_FLAIR = ["aboutme", "resume"]
  @@api_data = YAML::load_stream(File.open("./api_data.yaml")).first["api"]
  @@w = Redd.it(:userless, @@api_data["client_id"], @@api_data["secret"], user_agent: @@api_data["user_agent"])
  @@sub = @@w.subreddit_from_name("RaaB")

  def self.NAV_PAGES_FLAIR
    @@NAV_PAGES_FLAIR
  end

  def self.api_data
    @@api_data
  end

  def self.w
    @@w
  end

  def self.sub
    @@sub
  end
end
