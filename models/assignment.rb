module Database
  class Assignment
    include DataMapper::Resource

    belongs_to :channel, key: true
    belongs_to :subreddit, key: true

    before :destroy, :check_subreddit

    # If there are no more associated channels, delete the subreddit
    def check_subreddit
      sr = self.subreddit
      if ((sr.channels.count - 1) <= 0)
        sr.destroy!
      end
    end
  end
end
