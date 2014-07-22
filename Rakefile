DISTRIBUTE_TARGET = File.expand_path('../dist', __FILE__)

def copy_files(paths, strip_levels=nil)
  paths.each do |path|
    if strip_levels.nil?
      stripped_path = path
    else
      stripped_path = path.split('/')[strip_levels..-1].join('/')
    end
    destination = File.join(DISTRIBUTE_TARGET, stripped_path)
    puts '+ ' + destination
    FileUtils.mkdir_p(File.dirname(destination))
    FileUtils.cp(path, destination)
  end
end

task default: :test

task :test do
  ruby FileList['test/**/*_test.rb']
end

desc "Create a distribution directory with all the files needed to run the parser"
task dist: [:unpack_parslet, :copy_lib, :copy_parslet_lib] do
end

task :unpack_parslet do
  sh "gem unpack parslet --target tmp"
end

task :copy_lib do
  copy_files(FileList['lib/**/*.rb'])
end

task :copy_parslet_lib do
  copy_files(FileList['tmp/parslet*/lib/**/*.rb'], 2)
end