# RateFu
require 'acts_as_rateable'
require 'acts_as_rater'
require 'has_karma'
require 'models/rating.rb'

ActiveRecord::Base.send(:include, Rateable)
ActiveRecord::Base.send(:include, Rater)
ActiveRecord::Base.send(:include,Karma)
RAILS_DEFAULT_LOGGER.info "** rate_fu: initialized properly."
