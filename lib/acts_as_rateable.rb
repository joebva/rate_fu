# ActsAsRateable
module Rateable #:nodoc:

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_rateable
      has_many :ratings, :as => :rateable, :dependent => :nullify

      include Rateable::InstanceMethods
      extend  Rateable::SingletonMethods
    end        
  end
  
  # This module contains class methods
  module SingletonMethods
    
    # Calculate the rating counts for all rateables of my type.
    def tally(options = {})
      find(:all, options_for_tally(options.merge({:order =>"count DESC" })))
    end

    # Options:
    #  :start_at    - Restrict the ratings to those created after a certain time
    #  :end_at      - Restrict the ratings to those created before a certain time
    #  :conditions  - A piece of SQL conditions to add to the query
    #  :limit       - The maximum number of rateables to return
    #  :order       - A piece of SQL to order by. Eg 'ratings.count desc' or 'rateable.created_at desc'
    #  :at_least    - Item must have at least X ratings
    #  :at_most     - Item may not have more than X ratings
    def options_for_tally (options = {})
        options.assert_valid_keys :start_at, :end_at, :conditions, :at_least, :at_most, :order, :limit

        scope = scope(:find)
        start_at = sanitize_sql(["#{Rating.table_name}.created_at >= ?", options.delete(:start_at)]) if options[:start_at]
        end_at = sanitize_sql(["#{Rating.table_name}.created_at <= ?", options.delete(:end_at)]) if options[:end_at]

        type_and_context = "#{Rating.table_name}.rateable_type = #{quote_value(base_class.name)}"

        conditions = [
          type_and_context,
          options[:conditions],
          start_at,
          end_at
        ]

        conditions = conditions.compact.join(' AND ')
        conditions = merge_conditions(conditions, scope[:conditions]) if scope

        joins = ["LEFT OUTER JOIN #{Rating.table_name} ON #{table_name}.#{primary_key} = #{Rating.table_name}.rateable_id"]
        joins << scope[:joins] if scope && scope[:joins]
        at_least  = sanitize_sql(["COUNT(#{Rating.table_name}.id) >= ?", options.delete(:at_least)]) if options[:at_least]
        at_most   = sanitize_sql(["COUNT(#{Rating.table_name}.id) <= ?", options.delete(:at_most)]) if options[:at_most]
        having    = [at_least, at_most].compact.join(' AND ')
        group_by  = "#{Rating.table_name}.rateable_id HAVING COUNT(#{Rating.table_name}.id) > 0"
        group_by << " AND #{having}" unless having.blank?

        { :select     => "#{table_name}.*, COUNT(#{Rating.table_name}.id) AS count", 
          :joins      => joins.join(" "),
          :conditions => conditions,
          :group      => group_by
        }.update(options)          
    end
  end
  
  # This module contains instance methods
  module InstanceMethods
    
    # Returns the count of all the ratings submitted
    def ratings_for
      Rating.count(:all, :conditions => [
        "rateable_id = ? AND rateable_type = ? AND rate = ?",
        id, self.class.name, true
      ])
    end
    
    # Returns the average rating as a float
    def rate_avg
      all_ratings = Rating.find(:all, :conditions => [
        "rateable_id = ? AND rateable_type = ?",
        id, self.class.name])
      total = 0.0
      all_ratings.each do |rating|
        total += rating.rating
      end
      ratings = all_ratings.size.to_f
      total/ratings
    end   

    # Returns the number of ratings submitted
    # for this rateable object
    def ratings_count
      self.ratings.size
    end
    
    # Returns an array of raters who rated this ob
    def raters_who_rated
      raters = []
      self.ratings.each { |r|
        raters << r.rater
        }
      raters
    end
    
    def rated_by?(rater)
      rtn = false
      if rater
        self.ratings.each { |r|
          rtn = true if (rater.id == r.rater_id && rater.class.name == r.rater_type)
        }
      end
      rtn
    end
    
    
  end
end

