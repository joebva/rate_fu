# ActsAsRater
module Rater #:nodoc:

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_rater
      has_many :ratings, :as => :rater, :dependent => :nullify  # If a rating entity is deleted, keep the ratings. 
      include Rater::InstanceMethods
      extend  Rater::SingletonMethods
    end
  end
  
  # This module contains class methods
  module SingletonMethods
  end
  
  # This module contains instance methods
  module InstanceMethods
    
    # Return how many ratings the rater has submitted
    def rate_count
      where = "rater_id = ? AND rater_type = ?", id, self.class.name
      Rating.count(:all, :conditions => where)

    end
    
    # Check if the rater rated this object returns boolean
    def rated?(rateable)
       0 < Rating.count(:all, :conditions => [
               "rater_id = ? AND rater_type = ? AND rateable_id = ? AND rateable_type = ?",
               self.id, self.class.name, rateable.id, rateable.class.name
               ])
    end
     
    # Rate the rateable object with integers
    def rate(rateable, rate)
      already_rated = Rating.find(:first, :conditions => [
               "rater_id = ? AND rater_type = ? AND rateable_id = ? AND rateable_type = ?",
               self.id, self.class.name, rateable.id, rateable.class.name
               ])
      if already_rated
        already_rated.update_attribute(:rating, rate)
      else
        rate = Rating.new(:rating => rate, :rateable => rateable, :rater => self)
        rate.save
      end
    end

    # return what integer value this rater rated the object
    def rater_rated(rateable)
      rate = Rating.find_by_rateable_id_and_rater_id_and_rateable_type(rateable, self, rateable.class.name)
      rate.rating if rate
    end

  end
end
