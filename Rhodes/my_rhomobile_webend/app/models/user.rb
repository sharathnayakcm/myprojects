class User < ActiveRecord::Base
  before_create :assign_session_key
  has_many :tweets

  # Paperclip
  has_attached_file :photo,
    :styles => {
    :thumb=> "100x100#",
    :small  => "150x150>",
    :medium => "300x300>",
    :large =>   "400x400>"
    }
=begin
  def self.login_session_key(email, password)
    user = User.find_by_email_and_password email, password
    if !user.nil?
      return user.session_key
    else
      return 'invalid'
    end
  end
=end
  
  def self.authenticate?(email, password)
    user = User.find_by_email_and_password email, password
    if user.nil?
      {:status => 'error'}
    else
      {:status => 'ok', :user_info => user}
    end
  end

  def self.info(id, url)
    user = User.find id
    if user.nil?
      {:status => 'invalid'}
    else
      user[:user_image_url] = url + user.photo.url(:medium)
      {:status => 'Ok', :user_info => user}
    end
  end

  def self.profile_pic(id, url, size)
    user = User.find id
    if user.nil?
      {:status => 'invalid'}
    else
      case size
      when 'thumb'
        profile_pic_url = url + user.photo.url(:thumb)
      when 'small'
        profile_pic_url = url + user.photo.url(:small)
      when 'medium'
        profile_pic_url = url + user.photo.url(:medium)
      when 'large'
        profile_pic_url = url + user.photo.url(:large)
      end
      {:status => 'Ok', :user => {:id=> user.id, :profile_pic_url => profile_pic_url}}
    end
  end
 
  private
  def assign_session_key
    self.session_key = rand(36**8).to_s(36) if self.new_record? and self.session_key.empty?
  end
end
