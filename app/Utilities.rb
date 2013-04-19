include ApplicationHelper

def test_sign_in(user)
	controller.sign_in(user)
end

def test_sign_out
	current_user = nil
    cookies.delete(:remember_token)
end