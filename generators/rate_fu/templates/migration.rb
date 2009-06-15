class RateFuMigration < ActiveRecord::Migration
  def self.up
    create_table :ratings, :force => true do |t|
      t.integer    :rating, :default => false
      t.references :rateable, :polymorphic => true, :null => false
      t.references :rater,    :polymorphic => true
      t.timestamps      
    end

    add_index :ratings, ["rater_id", "rater_type"],       :name => "fk_raters"
    add_index :ratings, ["rateable_id", "rateable_type"], :name => "fk_rateables"

    # If you want to enfore "One Person, One Rating" rules in the database, uncomment the index below
    # add_index :ratings, ["rater_id", "rater_type", "rateable_id", "rateable_type"], :unique => true, :name => "uniq_one_rating_only"
  end

  def self.down
    drop_table :ratings
  end

end