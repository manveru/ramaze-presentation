require 'ramaze'
require 'compass'

class Presenter < Ramaze::Controller
  map '/'
  helper :xhtml, :cache
  layout :default

  @guide = Hash[File.readlines('guide').map{|l| l.strip.split("\t") }]
  @order = File.readlines('order').map{|l| l.strip }

  class << self
    attr_reader :guide, :order
  end

  def guide; self.class.guide; end
  def order; self.class.order; end

  before_all do
    # comment out this call for production :)
    system('rake', 'build')

    @name = action.params.first || 'index'
    @now = order.index(@name) + 1
  end

  def index(page = 'index')
    @page = page
    file = "output/#{page}.html"

    cache_value(file, :ttl => 1) do
      nav_links + File.read(file)
    end
  end

  def list_of_slides
    [ '<ul>',
      Dir['input/*.txt'].map{|txt| "<li>#{a(File.basename(txt, '.txt'))}</li>" },
      '</ul>' ].join
  end

  def nav_links
    <<-'HTML'
<div class="nav">
  <div class="back">#{link_back}</div>
  #{progress_bar}
  <div class="forward">#{link_forward}</div>
</div>
  HTML
  end

  def link_back
    if back = order[order.index(@name) - 1]
      a guide[back], back
    end
  end

  def link_forward
    if forward = order[order.index(@name) + 1]
      a guide[forward], forward
    end
  end

  def progress_bar
    now = order.index(@name) + 1
    total = order.size
    width = ((100.0 / total) * now).to_i

    "<div class='progress'>
      <div class='bar-start'>1</div>
      <div class='bar-total'>
        <div class='bar-now' style='width:#{width}%'>#{now}</div>
      </div>
      <div class='bar-end'>#{total}</div>
     </div>"
  end
end

class CSS < Ramaze::Controller
  map '/css'
  provide :css, :engine => :Sass, :type => 'text/css'
  trait :sass_options => {
    :load_paths => Compass::Frameworks::ALL.map{|f| f.stylesheets_directory }
  }
end

Ramaze.start
