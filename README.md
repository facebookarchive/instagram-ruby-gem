The Instagram Ruby Gem
====================
A Ruby wrapper for the Instagram REST and Search APIs


Installation
------------
	gem install instagram


Follow @instagramapi on Twitter
----------------------------
You should [follow @instagramapi on Twitter](http://twitter.com/#!/instagramapi) for announcements,
updates, and news about the Instagram gem.


Join the mailing list!
----------------------
<https://groups.google.com/group/instagram-ruby-gem>


Does your project or organization use this gem?
-----------------------------------------------
Add it to the [apps](http://github.com/Instagram/instagram-ruby-gem/wiki/apps) wiki!


Sample Application
------------------
	require "sinatra"
	require "instagram"

	enable :sessions

	CALLBACK_URL = "http://localhost:4567/oauth/callback"

	Instagram.configure do |config|
	  config.client_id = "YOUR_CLIENT_ID"
	  config.client_secret = "YOUR_CLIENT_SECRET"
	end

	get "/" do
	  '<a href="/oauth/connect">Connect with Instagram</a>'
	end

	get "/oauth/connect" do
	  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
	end

	get "/oauth/callback" do
	  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
	  session[:access_token] = response.access_token
	  redirect "/feed"
	end

	get "/feed" do
	  client = Instagram.client(:access_token => session[:access_token])
	  user = client.user

	  html = "<h1>#{user.username}'s recent photos</h1>"
	  for media_item in client.user_recent_media
	    html << "<img src='#{media_item.images.thumbnail.url}'>"
	  end
	  html
	end


API Usage Examples
------------------
    require "rubygems"
    require "instagram"

    # Get a list of a user's most recent media
    puts Instagram.user_recent_media(777)

    # Get the currently authenticated user's media feed
    puts Instagram.user_media_feed

    # Get a list of recent media at a given location, in this case, the Instagram office
    puts Instagram.location_recent_media(514276)

    # All methods require authentication (either by client ID or access token).
	# To get your Instagram OAuth credentials, register an app at http://instagr.am/oauth/client/register/
    Instagram.configure do |config|
      config.client_id = YOUR_CLIENT_KEY
      config.access_token = YOUR_ACCESS_TOKEN
    end

    # Get a list of all the users you're following
    puts Instagram.follows

    # Get a list of media close to a given latitude and longitude
    puts Instagram.media_search("37.7808851","-122.3948632")

	# Get a list of the overall most popular media items
	puts Instagram.media_popular

	# Search for users on instagram, by name or username
	puts Instagram.user_search("shayne sweeney")


Contributing
------------
In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace)
* by refactoring code
* by closing [issues](http://github.com/Instagram/instagram-ruby-gem/issues)
* by reviewing patches


Submitting an Issue
-------------------
We use the [GitHub issue tracker](http://github.com/Instagram/instagram-ruby-gem/issues) to track bugs and
features. Before submitting a bug report or feature request, check to make sure it hasn't already
been submitted. You can indicate support for an existing issuse by voting it up. When submitting a
bug report, please include a [Gist](http://gist.github.com/) that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version, Ruby version, and
operating system. Ideally, a bug report should include a pull request with failing specs.


Submitting a Pull Request
-------------------------
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run <tt>rake doc:yard</tt>. If your changes are not 100% documented, go back to step 4.
6. Add specs for your feature or bug fix.
7. Run <tt>rake spec</tt>. If your changes are not 100% covered, go back to step 6.
8. Commit and push your changes.
9. Submit a pull request. Please do not include changes to the gemspec, version, or history file. (If you want to create your own version for some reason, please do so in a separate commit.)


Copyright
---------
Copyright (c) 2011 Instagram (Burbn, Inc).
See [LICENSE](https://github.com/Instagram/instagram-ruby-gem/blob/master/LICENSE.md) for details.
