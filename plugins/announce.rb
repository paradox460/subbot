class Announcer
  include Cinch::Plugin
  timer((CONFIG['reddit']['interval'].to_i), method: :announce)

  def announce
    @c = Snoo::Client.new

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
              Channel(c.name).msg("r/#{Format(:bold, t['data']['subreddit'])}: <#{t['data']['author'][0]}\u2063#{t['data']['author'][1..-1]}> #{t['data']['title']} (http://redd.it/#{t['data']['id']})")
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
