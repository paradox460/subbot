class Announcer
  include Cinch::Plugin
  timer((CONFIG['reddit']['interval'].to_i), method: :announce)

  def announce
    # Deal with the nil doesnt have a [] method shit
    account = CONFIG.fetch('reddit',{}).fetch('account',{}) || {}
    @c = Snoo::Client.new useragent: "Subbot IRC announcer bot", modhash: account.fetch('modhash', nil), cookies: account.fetch('cookies', nil)

    sr = Database::Subreddit.all
    subreddits = sr.map(&:name)
    data = []
    # reddit only lets you use a multi-reddit of 50 subreddits, so we split the subreddits into chunks
    if subreddits.count > 50
      subreddits.each_slice(50) do |s|
        begin
          d = @c.get_listing(subreddit: s.join('+'), page: 'new', limit: 100)
          data += d['data']['children']
        rescue => e
          error e
        end
        sleep 2
      end
    else
      begin
        d = @c.get_listing(subreddit: subreddits.join('+'), page: 'new', limit: 100)
        data += d['data']['children']
      rescue => e
        error e
      end
    end

    # Throw away anything older than our interval
    data.reject! do |t|
      Time.at(t['data']['created_utc']) <= Time.now - CONFIG['reddit']['interval'].to_i
    end
    # And sort it
    data = data.sort_by do |t|
      t['data']['created_utc']
    end
    data.reverse!

    # Start making the announcement, based on subreddit
    # This can get floody, theoretically, but real world experience shows it doesnt
    data.each do |t|
      begin
        debug "Starting channel lookup for #{t['data']['subreddit']}"
        channels = Database::Subreddit.first(:name.like => t['data']['subreddit']).channels
        debug "Got #{channels.count} channels: #{channels.map(&:name).join(', ')}"
        channels.each do |c|
          begin
            if bot.channels.include?(c.name)
              message = "/r/#{Format(:bold, t['data']['subreddit'])}: <#{t['data']['author']}> #{CGI.unescapeHTML(t['data']['title'])} ( http://redd.it/#{t['data']['id']} )"
              if File.extname(t["data"]["url"]) =~ /\A\.(png|gif|jpe?g|webp)\z/i
                message << " [ #{t["data"]["url"]} ]"
              else
                message << " [ #{t["data"]["domain"]} ]"
              end
              Channel(c.name).msg(message)
            end
          rescue => e
            error e
          end
        end
      rescue => e
        error e
      end
    end
  end
end
