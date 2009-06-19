class Rating < ActiveRecord::Base

  named_scope :for_rater,    lambda { |*args| {:conditions => ["rater_id = ? AND rater_type = ?", args.first.id, args.first.type.name]} }
  named_scope :for_rateable, lambda { |*args| {:conditions => ["rateable_id = ? AND rateable_type = ?", args.first.id, args.first.type.name]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "created_at DESC"

  # NOTE: Ratings belong to the "rateable" interface, and also to raters
  belongs_to :rateable, :polymorphic => true
  belongs_to :rater,    :polymorphic => true
  
  attr_accessible :rating, :rater, :rateable

  # Uncomment this to limit users to a single rating on each item. 
  # validates_uniqueness_of :rateable_id, :scope => [:rateable_type, :rater_type, :rater_id]

end