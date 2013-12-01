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
                  :inventory,
                  :inventory_attributes

  validates :email, :presence => true,
                    :uniqueness =>  { :case_sensitive => false }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :phone, :presence => true
  validates :password, 
            :if => "should_validate_password?",
            :presence => true,
            :confirmation => true,
            :length => { :within => 6..40 }

  validates_length_of :phone, :minimum => 9, :maximum => 14
   

  before_save :encrypt_password, :default_values, :update_inventory
  after_save :create_cart
  
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

  def name
    first_name + " " + last_name
  end

  def pending_payment
   return total_payment - processed_payment
  end

  def markup_payment
    return (pending_payment * 1.1).round(2)
  end

  def markup
    return (pending_payment * 0.1).round(2)
  end

  def total_payment
    total = 0.0
    Purchase.where("user_id = ? ", id).each do |purchase|
      total += purchase.full_price
    end
    return total
  end

  def processed_payment
    paid = 0.0
    Purchase.where("user_id = ? AND paid = ?", id, true).each do |purchase|
      paid += purchase.full_price
    end
    return paid
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

      if !self.inventory.nil? && !self.inventory.description.nil?
        self.inventory.description.gsub(/\n/, '<br>');
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

    def create_cart
      @cart = Cart.new(:user_id => self.id)
      @cart.save
    end

end



