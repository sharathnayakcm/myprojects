class User < ActiveRecord::Base
  #acts_as_authentic
  has_many :tweet
  has_many :follows


  def my_following(current_user)
    my_followings = Follow.find(:all, :conditions => "follow_id = #{current_user.id}")
  end

    def self.authenticate?(login,email)
    user = User.find_by_login_and_email login,email
    if user.nil?
      {:status => 'error'}
    else
      {:status => 'ok', :user_info => user}
    end
  end

end
