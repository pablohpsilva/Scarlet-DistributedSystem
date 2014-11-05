class LoadBalancerProxy
  private
    @server_stack
    @server_in_use
    @max_connections

  public
    def initialize (instance = nil, connections = 1)
      @server_stack = []
      @server_in_use = (instance != nil) ? StackNode.new(instance) : nil
      @max_connections = connections
    end

    def addServer serverInstance
      if @server_in_use == nil
        @server_in_use = serverInstance
        @server_stack.push serverInstance
      else
        @server_stack.push serverInstance
      end
    end

    def getServer
      if @server_in_use == nil
        print 'You should addServer before calling a getServer. Now you\'ll get a nil =D'
        return nil
      elsif @server_in_use.getController != @max_connections
        @server_in_use.changeController
        return @server_in_use.getInstance
      else
        @stack_aux = []
        @server_stack.length.times do |stack|
          @aux = stack.pop
          if @aux.getController != @max_connections
            @server_stack.push @aux
            @server_in_use = @aux
            @server_in_use.changeController
            return @server_in_use
          end
        end
      end
    end

end

