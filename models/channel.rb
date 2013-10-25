module Database
  class Channel
    include DataMapper::Resource

    property :id, Serial
    property :name, String
    property :creator, String

    has n, :assignments
    has n, :subreddits, through: :assignments
  end
end
