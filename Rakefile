require 'rake'
require 'pathname'
require 'nokogiri'
require 'json'

rule(/\.html$/ => [proc{|task_name|
  base = File.basename(task_name, '.html')
  source = File.join('input', "#{base}.txt")
}]) do |t|
  sh "asciidoc --no-header-footer -o #{t.name} #{t.source}"
end    

def title_of(name, names)
  names.empty? ? title : [[name, title], build(names)]
end

def build(names)
  title_of(names.shift, names)
end

task :build do
  titles = {}

  Pathname.glob 'input/*.txt' do |txt|
    basename = txt.basename('.txt').to_s
    html = "output/#{basename}.html"

    Rake::Task[html].invoke

    title = Nokogiri::HTML(File.read(html)).at('h2').inner_html
    titles[basename] = title
  end
  p titles

  File.open('guide', 'w+') do |guide|
    File.open('order') do |order|
      order.each_line do |line|
        line.strip!
        guide.puts("#{line}\t#{titles[line]}")
      end
    end
  end
end
