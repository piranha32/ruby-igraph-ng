require 'hoe'
require 'rdoc/task'

$LOAD_PATH.unshift("./ext")

#begin 
#  require 'igraph-ng'
#rescue RuntimeError
#end

hoe = Hoe.spec("igraph-ng") do |p|
  developer("Alex Gutteridge","ag357@cam.ac.uk")
  developer("Jacek Radzikowski","jacek.radzikowski@gmail.com")
  p.urls = ["http://igraph.rubyforge.org/", "https://github.com/piranha32/ruby-igraph-ng"]
  
  p.description = p.paragraphs_of("README.txt",1..3)[0]
  p.summary     = p.paragraphs_of("README.txt",1)[0]
  p.changes     = p.paragraphs_of("History.txt",0..1).join("\n\n")
  p.licenses    = "GNU LESSER GENERAL PUBLIC LICENSE Version 2.1"
  p.version     = "0.1.0"
  
  p.clean_globs = ["ext/*.o","ext/*.so","ext/Makefile","ext/mkmf.log","**/*~","email.txt","manual.{aux,log,out,toc,pdf}"]
  
  p.extra_rdoc_files = %w[TODO.txt]
  
  p.spec_extras = {
    :extensions    => ['ext/extconf.rb'],
    :require_paths => ['test'],
    :has_rdoc      => true,
    :extra_rdoc_files => ["README.txt","History.txt","License.txt"],
    :rdoc_options  => ["--exclude", "test/*",
    		       "--exclude", "ext/*", 
    		       "--main", "README.txt", 
    		       "--inline-source"]
  }

end
  


hoe.spec.dependencies.delete_if{|dep| dep.name == "hoe"}

IGRAPH = '/tmp/igraph'

desc "Uses extconf.rb and make to build the extension"
task :build_extension => ['ext/igraph.so']
SRC = FileList['ext/*.c'] + FileList['ext/*.h']
file 'ext/igraph.so' => SRC do
  Dir.chdir('ext')
  system("ruby extconf.rb --with-igraph-include=#{IGRAPH}/include/igraph --with-igraph-lib=#{IGRAPH}/lib/")
  system("make")
  Dir.chdir('..')
end

task :test => [:build_extension]

#task :gem => [:build_extension]
