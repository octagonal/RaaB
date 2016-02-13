# RaaB
Use Reddit as a Backend for your blog

## Notice

This is really just a personal project at the moment, lots of stuff is undocumented/hardcoded. Do not use in production unless you are me.

## Building

* Add a .yaml file at `/` called `api_data.yaml`

 * Add your Reddit API `secret`, `client_id` and `user_agent` to it. 
   
   Getting this stuff is pretty easy, have a look at [reddit/reddit/wiki/API](https://github.com/reddit/reddit/wiki/API) to get started.

 * You also need to generate an initialization vector if you want to encrypt/decrypt posts. 
   
   `<your favourite crypto library>` should be able to do this without a hitch.
   
The yaml file should end up looking like this: 

    api:
      secret: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      client_id: "XXXXXXXXXXXXXX"
      user_agent: "Web:XXXX:vn.n.n (by /u/XXXXX)"
      iv: "XXXXXXXXXXXXXXXXXXXXXXXX"
      subreddit: "XXXXXXXX"

 * Running the app itself is as simple as `ruby routes.rb`
