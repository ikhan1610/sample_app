class User < ApplicationRecord
	attr_accessor :remember_token
	before_save { email.downcase! }
	validates :name,  presence: true, length: {maximum: 50}
	VALIDATE_EMAIL_REGEX = /\A[\w\+.-]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},
								format: {with: VALIDATE_EMAIL_REGEX},
								uniqueness: true
	validates :password, presence: true, length: {minimum: 6}
	has_secure_password			

	#Creates a password digest for testing data in fixtures, users.yml
	def User.digest(arg)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
													  BCrypt::Engine.cost
		BCrypt::Password.create(arg, cost: cost)
									
	end			

	#Returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end		

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
		remember_digest
	end

	# Returns a session token to prevent session hijacking.
  	# We reuse the remember digest for convenience.
	def session_token
		remember_digest || remember
		
	end

	#Forget user
	def forget
		update_attribute(:remember_digest,nil)
		
	end

	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

			
end
