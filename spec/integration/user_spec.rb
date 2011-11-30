require 'spec_helper'

def sign_in_as(user, password)
  password = "password" unless password
  user = User.create(:password => password, :password_confirmation => password, :email => user)
  user.save!
  visit home_path
  click_link_or_button('Sign in')
  fill_in 'Email', :with => user.email
  fill_in 'Password', :with => password
  click_link_or_button('Sign in')
  user      
end 
def sign_out
  click_link_or_button('Log Out')   
end

describe User do
  it "allows users to login", :js => true do
    DeviseSessionMock.enable(Fabricate(:user))
    save_and_open_page
    page.should have_content "Signed in successfully."
    DeviseSessionMock.disable
  end
end
