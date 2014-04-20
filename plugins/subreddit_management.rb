require './lib/common_functions'
require "active_support/core_ext/array/conversions"

class SubredditManagement
  include Cinch::Plugin
  include CommonFunctions

  set :plugin_name, "Subreddit Management"
  set :help, "Usage: #{CONFIG['prefix']}subreddit (add|del|list) <subreddit>"

  match /subreddit add ([[:alnum:]]\w{1,20})/, method: :add_subreddit
  match /subreddit del ([[:alnum:]]\w{1,20})/, method: :del_subreddit
  match /subreddit list/, method: :list_subreddits


  def add_subreddit(m, subreddit)
    admincheck(m) do
      opcheck(m) do
        if subreddit =~ Regexp.union(SubbotConstants::BADSUBS)
          m.reply "Try a real subreddit please"
        else
          sr = Database::Subreddit.first_or_create(name: subreddit)
          c = Database::Channel.first_or_create(name: m.channel.to_s)
          c.subreddits << sr
          if c.save
            m.reply "Added!"
          else
            m.reply CONFIG['messages']['failure']
          end
        end
      end
    end
  end

  def del_subreddit(m, subreddit)
    admincheck(m) do
      opcheck(m) do
        c = Database::Channel.first(name: m.channel.to_s)
        sr = Database::Subreddit.first(name: subreddit)
        if Database::Assignment.get(c.id, sr.id).destroy
          m.reply "Removed!"
        else
          m.reply CONFIG['messages']['failure']
        end
      end
    end
  end

  def list_subreddits(m)
    subs = Database::Channel.first(name: m.channel.to_s).subreddits
    if subs.empty?
      m.reply "No subreddits assigned!"
    else
      m.safe_reply subs.map { |x| "/r/#{x.name}" }.to_sentence
    end
  end
end
