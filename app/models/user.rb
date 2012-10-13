class User < ActiveRecord::Base
  validates :email, :presence => true,
                    :uniqueness =>  { :case_sensitive => false }
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password, :presence => true
  validates_length_of :password, :minimum => 6
  validates_length_of :password, :maximum => 40
  before_save :encrypt_password

  private

    def encrypt_password
      self.salt = make_salt
      self.password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
