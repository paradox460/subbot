module CommonFunctions
  # Check if the user is ops in a channel
  def opcheck(m)
    if m.channel.opped?(m.user)
      yield
    else
      m.user.notice "Sorry, you need to be opped to do that"
    end
  end

  def admincheck(m)
    if !CONFIG['admins'].nil? && !CONFIG['admins'].empty? && !CONFIG['admins'].include(m.user.authname)
      return false
    else
      yield
    end
  end
end
