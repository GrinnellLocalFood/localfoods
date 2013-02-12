class User < ActiveRecord::Base

  attr_accessor :password_confirmation, :password, :old_password
  attr_accessible :first_name,
                  :last_name,
                  :email, 
                  :phone,
                  :password, #user entered password
                  :password_confirmation,
                  :old_password,
                  :admin,
                  :coordinator,
                  :producer,
                  :inventory_attributes

  validates :email, :presence => true,
                    :uniqueness =>  { :case_sensitive => false }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password, 
            :if => "should_validate_password?",
            :presence => true,
            :confirmation => true,
            :length => { :within => 6..40 }

  validates_length_of :phone, :minimum => 10, :maximum => 15, :allow_blank => true

   

  before_save :encrypt_password, :default_values, :update_inventory
  
  before_validation :format_values

  has_one :inventory, :foreign_key => "id", :autosave => true, :dependent => :destroy
  has_one :cart

  accepts_nested_attributes_for :inventory, :update_only => true

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password) 
  end

  def send_password_reset
    create_password_reset
    UserMailer.password_reset(self).deliver
  end

  def create_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
  end

  private

    def generate_token(column)
      begin
      self[column] = SecureRandom.hex
      end while User.exists?(column => self[column])
    end

    #validate password either if:
    # => encrypted_password field is nil (i.e user has just registered) 
    # or
    # => if password field is nil (i.e user is submitting from account info edit form)
    def should_validate_password?
      self.encrypted_password.nil? || !self.password.nil?
    end

    def default_values
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

    def update_inventory
      if self.inventory.nil?
        if self.producer
          raise "Inventory could not be created" unless create_inventory
        end
      elsif !self.producer
          self.inventory.hide
      end
    end

end



