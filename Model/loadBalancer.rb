
@stack = []

def addServer(scarletInstance)
  @stack.push scarletInstance
end

def getServer
  return @stack.pop
end

