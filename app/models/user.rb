class User < ActiveRecord::Base

  attr_accessor :password_confirmation, :password2
  attr_accessible :first_name,
                  :last_name,
                  :display_name, 
                  :email, 
                  :phone,
                  :password2, #encrypted password
                  :password_confirmation

  validates :email, :presence => true,
                    :uniqueness =>  { :case_sensitive => false }
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password2, 
            :unless => "password2.empty?",
            :presence => true,
            :confirmation => true,
            :length => { :within => 6..40 }


      

  before_save :encrypt_password, :default_values

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def has_password?(submitted_password)
    password == encrypt(submitted_password) 
  end

  private

    def default_values
      if self.display_name == ""
        self.display_name = self.first_name + " " + self.last_name
      end
    end

    def encrypt_password
      self.salt = make_salt
      self.password = encrypt(password2)
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

    def self.authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
  end
end
