module DrinksHelper
  def render_with_links(text)
    output = ""
    chunks = text.split(/(http\:\/\/\S+)/)
		chunks.each { |c|
  		m = c.match(/(http\:\/\/\S+)/)
  		if m
  			output += "<a href=\"" + h(m[1]) + "\">" + h(m[1]) + "</a>"
  		else
  			output += h(c)
  		end
		}
		
		output
  end
end
