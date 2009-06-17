class RateFuGenerator < Rails::Generator::Base 

  def manifest 
    record do |m| 
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => 'rate_fu_migration'
      m.directory File.join('app/views/ratings')
      m.template 'rating.html.erb', File.join('app/views/ratings', "_rating.html.erb")
      m.template 'rate.rjs', File.join('app/views/ratings', "rate.rjs")
    end 
  end
end
