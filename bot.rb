require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :db, :irc)

require './conf/database'
require 'yaml'
require './lib/constants'

CONFIG = YAML.load_file('conf/config.yml')

require_all "./plugins/*"

bot = Cinch::Bot.new do
  configure do |c|
    c.server = CONFIG['irc']['server']
    c.nick = CONFIG['irc']['nick']
    c.port = CONFIG['irc']['port']
    c.ssl.use = CONFIG['irc']['ssl']
    c.modes = CONFIG['irc']['modes'].chars
    c.sasl.username = CONFIG['irc']['sasl']['username']
    c.sasl.password = CONFIG['irc']['sasl']['password']
    c.channels = Database::Channel.all.map(&:name)
    c.delay_joins = 10
    c.plugins.prefix = /^#{Regexp.escape(CONFIG['prefix'])}/
    c.plugins.plugins = [ChannelManagement, SubredditManagement, Announcer]
  end
end

bot.start
