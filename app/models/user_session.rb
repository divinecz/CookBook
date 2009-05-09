class UserSession < Authlogic::Session::Base
  
  def self.current_user_session
    return @current_user_session if defined? @current_user_session
    @current_user_session = find
  end
  
  def self.current_user
    return @current_user if defined? @current_user
    @current_user = current_user_session && current_user_session.user
  end
end