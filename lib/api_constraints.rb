# API String:
# application/vnd.drink.v1

class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end
    
  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.drink.v#{@version}")
  end
end
