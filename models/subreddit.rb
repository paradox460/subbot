module Database
  class Subreddit
    include DataMapper::Resource

    property :id, Serial
    property :name, String

    has n, :assignments
    has n, :channels, through: :assignments    
  end
end
