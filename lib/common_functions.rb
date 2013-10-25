module CommonFunctions
  def opcheck(m)
    if m.channel.opped?(m.user)
      yield
    else
      m.user.notice "Sorry, you need to be opped to do that"
    end
  end
end
