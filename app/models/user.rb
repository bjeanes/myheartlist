class User < ActiveRecord::Base
  has_many :items
  has_many :hearts, :through=>:items

  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation
  
  attr_accessor :password
  before_create :prepare_password
  
  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  
  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.matching_password?(pass)
  end
  
  def self.find_id_or_username(params)
    find_by_id(params) || find_by_username(params)
  end

  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end


  def create_heart params
    heart = Heart.find_or_create_by_name(params[:name])
    if hearts.include? heart
      false
    else
      hearts << heart
    end
  end

  def to_param
    username
  end


  private
  
  def prepare_password
    self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
    self.password_hash = encrypt_password(password)
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
end
