class Item < ActiveRecord::Base
  belongs_to :user
  belongs_to :heart, :counter_cache => true
  acts_as_list :scope => :user
#  validates_uniqueness_of :heart_id, :scope=>:user_id

end
