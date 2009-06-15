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
    
    # Usage user.vote_count(true)  # All +1 votes
    #       user.vote_count(false) # All -1 votes
    #       user.vote_count()      # All votes
    
    def vote_count(for_or_against = "all")
      where = (for_or_against == "all") ? 
        ["voter_id = ? AND voter_type = ?", id, self.class.name ] : 
        ["voter_id = ? AND voter_type = ? AND vote = ?", id, self.class.name, for_or_against ]
                    
      Vote.count(:all, :conditions => where)

    end
            
    def voted_for?(voteable)
       0 < Vote.count(:all, :conditions => [
               "voter_id = ? AND voter_type = ? AND vote = ? AND voteable_id = ? AND voteable_type = ?",
               self.id, self.class.name, true, voteable.id, voteable.class.name
               ])
     end

     def voted_against?(voteable)
       0 < Vote.count(:all, :conditions => [
               "voter_id = ? AND voter_type = ? AND vote = ? AND voteable_id = ? AND voteable_type = ?",
               self.id, self.class.name, false, voteable.id, voteable.class.name
               ])
     end

     def voted_on?(voteable)
       0 < Vote.count(:all, :conditions => [
               "voter_id = ? AND voter_type = ? AND voteable_id = ? AND voteable_type = ?",
               self.id, self.class.name, voteable.id, voteable.class.name
               ])
     end
            
    def vote_for(voteable)
      self.vote(voteable, true)
    end
    
    # Added this to rate the voteable model with integers
            # instead of boolean
            def rate(voteable, rate)
              already_voted = Vote.find(:first, :conditions => [
                       "voter_id = ? AND voter_type = ? AND voteable_id = ? AND voteable_type = ?",
                       self.id, self.class.name, voteable.id, voteable.class.name
                       ])
              if already_voted
                already_voted.update_attribute(:vote, rate)
              else
                vote = Vote.new(:vote => rate, :voteable => voteable, :voter => self)
                vote.save
              end
            end

            # return what this student rated the object at
            def student_rated(voteable)
              vote = Vote.find_by_voteable_id_and_voter_id_and_voteable_type(voteable, self, voteable.class.name)
              vote.vote if vote
            end
            
    def vote_against(voteable)
      self.vote(voteable, false)
    end

    def vote(voteable, vote)
      vote = Vote.new(:vote => vote, :voteable => voteable, :voter => self)
      vote.save
    end

  end
end
