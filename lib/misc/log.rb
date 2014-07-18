require 'logger'

# A wrapper over Ruby logger interface.  There is only one logger,
# which is invoked by the Log class, e.g. Log.info( ).  The
# Log class accepts all methods a Ruby logger object accepts.

class Log
end

class << Log
  LogFile = '.urcc_log'

  # forward logging calls
  def method_missing( m, *args )
    @log = @log || Logger.new( LogFile )
    @log.send( m, *args )
  end

  def reset
    File.delete( LogFile ) if File.exist?( LogFile )
  end
end
