module SessionTestHelper
  def sign_in(user)
    user = users(user) unless user.is_a? User
    post login_url, params: {login: {email_address: user.email_address, password: "asdfasdf"}}
    assert cookies[:session_id].present?
  end
end
