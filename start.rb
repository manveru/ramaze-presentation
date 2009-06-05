require 'ramaze'

class Presenter < Ramaze::Controller
  map '/'
  helper :xhtml, :cache
  layout :default

  def index(page = 'index')
    cached("output/#{page}.html")
  end

  def cached(file)
    cache_value(file, :ttl => 60) do
      system('rake', file)
      File.read(file)
    end
  end
end

Ramaze.start
