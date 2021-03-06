# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user  do |user|
  user.first_name            "Michael"
  user.last_name			 "Hartl"
  user.email                 "mhartl" + rand(100000).to_s() + "@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.after_build do |f|
  	f.cart ||= Cart.create!(:user_id => f.id)
  end
end