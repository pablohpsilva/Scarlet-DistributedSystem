class StackNode
  private
    @object_instance
    @controller

  public
    def initialize instance
      @object_instance = instance
      @controller = 0
    end

    def getInstance
      return @object_instance
    end

    def getController
      return @controller
    end

    def changeController
      @controller += 1
    end
end