require 'rake'

rule(/\.html$/ => [proc{|task_name|
  base = File.basename(task_name, '.html')
  source = File.join('input', "#{base}.txt")
}]) do |t|
  sh "asciidoc --no-header-footer -o #{t.name} #{t.source}"
end    
