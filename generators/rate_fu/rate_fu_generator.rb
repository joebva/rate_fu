class RateFuGenerator < Rails::Generator::Base 

  def manifest 
    record do |m| 
      # Create a migration from the template
      m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => 'rate_fu_migration'
      # Create the directory app/views/ratings
      m.directory File.join('app/views/ratings')
      # Copy the file rate.rjs to /app/views/ratings/
      m.file('rate.rjs', 'app/views/ratings/rate.rjs')
      # Copy the partial _rating.html.erb to /app/views/ratings
      m.file('_rating.html.erb', 'app/views/ratings/_rating.html.erb')
      # Copy the stars.gif image into /public/images
      m.file('stars.gif', 'public/images/stars.gif')
    end 
  end
end

