##### Rating Stars #####
require 'rating_stars/rating_stars_helper'
require 'css_template'
ActionController::Base.helper RatingStars::RatingStarsHelper

# RateFu
require 'acts_as_rateable'
require 'acts_as_rater'
require 'has_karma'

ActiveRecord::Base.send(:include, Rateable)
ActiveRecord::Base.send(:include, Rater)
ActiveRecord::Base.send(:include,Karma)
RAILS_DEFAULT_LOGGER.info "** rate_fu: initialized properly."

%w{ models controllers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end
