class LoadList
  private
    @max_counter
    @my_instance
    @counter
  public
    def initialize(instance, max_counter)
      @max_counter = max_counter
      @my_instance = instance
      @counter = -1
    end

    def get_counter
      return @counter
    end

    def get_instance
      #self.add_counter
      ++@counter
      return (self.get_counter <= @max_counter) ? @my_instance : nil
    end

    def add_counter
      @counter = @counter + 1
    end
end