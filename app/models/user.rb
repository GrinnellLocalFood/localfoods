class User < ActiveRecord::Base

  attr_accessor :password_confirmation
  attr_accessible :first_name,
                  :last_name,
                  :display_name, 
                  :email, 
                  :phone,
                  :password, 
                  :password_confirmation

  validates :email, :presence => true,
                    :uniqueness =>  { :case_sensitive => false }
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password, 
            :presence => true,
            :length => { :within => 6..40 }

  before_save :encrypt_password, :default_values

  private

    def default_values
      self.display_name ||= self.first_name + " " + self.last_name
    end
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
