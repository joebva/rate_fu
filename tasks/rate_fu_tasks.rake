# desc "Explaining what the task does"
# task :rate_fu do
#   # Task goes here
# end
def copy(file_name, from_dir, to_dir)
  FileUtils.mkdir to_dir unless File.exist?(File.expand_path(to_dir))
  from = File.expand_path(File.join(from_dir,file_name))
  to = File.expand_path(File.join(to_dir, file_name))
  puts " creating: #{to}"
  FileUtils.cp from, to unless File.exist?(to)
end
 
def copy_image(file_name)
  plugin_images = File.join(File.dirname(__FILE__), '..', 'images')
  app_images = File.join(RAILS_ROOT, 'public/images')
  copy file_name, plugin_images, app_images
end
 
desc "Copies the assets to the public folder"
namespace :rake_fu do
  task :setup do
    copy_image 'stars.gif'
  end
end