require_all './models/*'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db/subbot.db")

DataMapper::Logger.new($stdout, :debug)

DataMapper.finalize

