class User < ActiveRecord::Base

  attr_accessor :password_confirmation, :password
  attr_accessible :first_name,
                  :last_name,
                  :display_name, 
                  :email, 
                  :phone,
                  :password, #user entered password
                  :password_confirmation,
                  :admin,
                  :coordinator,
                  :farmer

  validates :email, :presence => true,
                    :uniqueness =>  { :case_sensitive => false }
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password, 
            :if => "should_validate_password?",
            :presence => true,
            :confirmation => true,
            :length => { :within => 6..40 }

  validates_length_of :phone, :minimum => 10, :allow_blank => true

  before_save :encrypt_password, :default_values

  before_validation :format_values

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password) 
  end

  private

    #validate password either if:
    # => encrypted_password field is nil (i.e user has just registered) 
    # or
    # => if password field is nil (i.e user is submitting from account info edit form)
    def should_validate_password?
      self.encrypted_password.nil? || !self.password.nil?
    end

    def default_values
      if self.display_name == ""
        self.display_name = self.first_name + " " + self.last_name
      end
    end

    def format_values
      if self.phone != "" && !self.phone.nil?
        self.phone = self.phone.gsub(/\D/,'');
      end
    end

    #encrypt password only if the password field has something in it
    def encrypt_password
      unless self.password.nil?
        self.salt = make_salt
        self.encrypted_password = encrypt(password)
      end
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
