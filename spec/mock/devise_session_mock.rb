require 'spec_helper'

# In order to fake a Devise sign-in user in integration testing ; just do it :
#   DeviseSessionMock.enable(Factory :user)
#
# BEWARE: Sometimes this mock screw up your integration testing suite. (because stubbed methods are not reloaded suite after suite)
# So, you HAVE TO call DeviseSessionMock.disable. The easiest way to ensure everything will be ok is to setup a before.each in RSpec.configure :
# RSpec.configure do |config|
#   config.before :each, :type => :integration do
#     DeviseSessionMock.disable
#   end
# end
#
# BEWARE: Don't call this mock for functionnal (controller_test)... Devise provide support for this kind of testing

module DeviseSessionMock

# configuration options, store controllers & helpers to stubs.
  #CONTROLLERS_TO_STUB = [UserController]
  #HELPERS_TO_STUB = [FooHelper]

  mattr_accessor :current_user

# public interfaces
  # fakes devise current_user
  def self.enable(mock_user)
    setup(mock_user)
  end

  # frees devise current_user
  def self.disable()
    setup()
  end

  private
  # helpers
    # setup session mocking.
    # if user is nil, you are not signed in
    # if user is not nil, you are signed in
    def self.setup(mock_user = nil)
      @@current_user = mock_user
      #enable_for_controller
      #enable_for_helper
    end

    def self.signed_in?
      DeviseSessionMock.current_user.nil? ? false : true
    end

    # Fake logged in user for controller
    def self.enable_for_controller
      CONTROLLERS_TO_STUB.each do | class_name |
        class_name.any_instance.stubs(:authenticate_user!).returns(signed_in?)
        class_name.any_instance.stubs(:current_user).returns(DeviseSessionMock.current_user)
        class_name.any_instance.stubs(:user_signed_in?).returns(signed_in?)
      end
    end

    # Fake logged in user for helper
    # we use define_method cause stubbing on module does not works (or i failed...)
    def self.enable_for_helper
      HELPERS_TO_STUB.each do | module_name |
        module_name.send(:define_method, :user_signed_in?, Proc.new{signed_in?})
        module_name.send(:define_method, :current_user, Proc.new{DeviseSessionMock.current_user})
      end
    end
end
