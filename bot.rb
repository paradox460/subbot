require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :db, :irc)

require './conf/database'
require 'yaml'

CONFIG = YAML.load_file('conf/config.yml')

require_all "./plugins/*"

bot = Cinch::Bot.new do
  configure do |c|
    c.server = CONFIG['irc']['server']
    c.nick = CONFIG['irc']['nick']
    c.channels = Database::Channel.all.map(&:name)
    c.plugins.prefix = /^#{Regexp.escape(CONFIG['prefix'])}/
    c.plugins.plugins = [ChannelManagement, SubredditManagement, Announcer]
  end
end

bot.start
