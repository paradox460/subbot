require './lib/common_functions'

class ChannelManagement
  include Cinch::Plugin
  include CommonFunctions


  set :plugin_name, 'Channel Management'
  set :help, "Usage: #{CONFIG['prefix']}part to remove the bot from the channel"

  match /part/, method: :part_chan

  listen_to :invite, method: :join_chan

  def part_chan m
    admincheck(m) do
      bot.part m.channel
      c = Database::Channel.first(name: m.channel.to_s)
      c.assignments.destroy
      c.destroy
    end
  end

  def join_chan m
    admincheck(m) do
      bot.join m.channel
      Database::Channel.first_or_create(name: m.channel.to_s, creator: m.user.to_s)
    end
  end
end
