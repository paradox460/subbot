require 'snoo'
require 'io/console'

puts "Enter your reddit username and password when prompted."
puts '-' * $stdin.winsize[1]

print "Username: "
username = gets.chomp

print "Password: "
password = $stdin.noecho(&:gets).chomp

puts "\n" + '-' * $stdin.winsize[1]


@s = Snoo::Client.new(username: username, password: password)

puts "Copy and paste the following to your config file:"

puts "modhash: \"#{@s.modhash}\""
puts "cookies: \"#{@s.cookies.split(/(reddit_session=.*?);/)[1]}\""
