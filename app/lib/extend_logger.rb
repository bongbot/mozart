class ActiveSupport::Logger
  def debugT(str)
    debug  "#{str}  /**#{__FILE__}:#{__LINE__}"
  end
end

module ExtendLogger

end