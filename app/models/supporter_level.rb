class SupporterLevel < ActiveRecord::Base
  
  belongs_to :conference
  has_many :supporter_registrations

  attr_accessible :conference, :title, :url, :price, :currency
  
  validates :title, :presence => true
  validates :currency, :presence => true, :if => :condition_price?
  validates :price, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :url, :format => URI::regexp(/(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix), :allow_blank => true
  
  def condition_price?
    price != 0
  end
end
