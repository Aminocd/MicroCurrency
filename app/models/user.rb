class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Devise::JWT::RevocationStrategies::Whitelist
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :jwt_authenticatable, :omniauthable, :jwt_revocation_strategy => self, :omniauth_providers => [:facebook, :google_oauth2]
  validates :username, uniqueness: true, on: [:update], if: :username_being_changed? # 3/2/2020 - making this validation conditional on username being updated, because every time a user logs in using OAuth authentication, an update is done to update the 'last logged in' times, and for users that have not yet inputted their username, the 'nil' value will result in a validation error due to multiple users existing with 'nil' usernames(because this is the default state of new user accounts before they are activated). By only validating :username uniqueness when the :username is being updated, OAuth logins won't trigger errors for new nil-username accounts that have yet to be activated

  validates :username, presence: true, on: [:update], if: :username_being_changed? # 9/14/2018 - doesn't allow nil value username when it is being updated  
  validates :username, uniqueness: true, on: [:create], if: :username_not_nil?

  validates_with SocialLoginValidator, on: [:create, :update], if: :omniauth_user?

  #Ben 6/17/2018 I removed the auth token column in favor of the whitelisted_jwt strategy in the devise-jwt gem.  This allows users to login with multiple devices and uses JWTs which are mobile friendly
  # validates :auth_token, uniqueness: true

  # def generate_authentication_token!
	# begin
	#   self.auth_token = Devise.friendly_token
	# end while self.class.exists?(auth_token: auth_token)
  # end
  #
  # before_create :generate_authentication_token!

  has_many :products, inverse_of: :user, dependent: :destroy
  has_many :orders, inverse_of: :user, dependent: :destroy
  has_many :claimed_currencies, inverse_of: :user
  has_many :attempted_linkages, inverse_of: :user
  #Ben 6/17/2018 The two methods below are required for omniauth to work
  def self.new_with_session(params, session)
   super.tap do |user|
     if data = session["devise.provider_data"] && session["devise.provider_data"]["extra"]["raw_info"]
       user.email = data["email"] if user.email.blank?
     end
   end
 end

 def self.from_omniauth(auth)
    u = User.find_by(email: auth.info.email)
    if u.present?
      u.provider = auth.provider #Ben 6/28/2016 This will raise a validation error if the providers are different preventing users from logging in with multiple providers
      u.uid = auth.uid
      u.save
    else
      u = create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.password_confirmation = user.password
      end
    end
    u
  end

  def omniauth_user?
    self.provider.present? && self.uid.present?
  end

  def user_being_activated?
    new_active_state = self.active    
    old_active_state = User.find(self.id).active
    if (new_active_state == true && old_active_state == false) 
      true
    else
      false
    end
  end

  def username_being_changed?
    new_username_state = self.username    
    old_username_state = User.find(self.id).username
    if (new_username_state != old_username_state) 
      true
    else
      false
    end
  end

  def username_not_nil?
    unless self.username.nil?
      true
    else
      false
    end
  end
end
