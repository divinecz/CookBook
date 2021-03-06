require File.dirname(__FILE__) + '/../test_helper.rb'

module SessionTest
  module BruteForceProtectionTest
    class ConfigTest < ActiveSupport::TestCase
      def test_consecutive_failed_logins_limit
        UserSession.consecutive_failed_logins_limit = 10
        assert_equal 10, UserSession.consecutive_failed_logins_limit
    
        UserSession.consecutive_failed_logins_limit 50
        assert_equal 50, UserSession.consecutive_failed_logins_limit
      end
      
      def test_failed_login_ban_for
        UserSession.failed_login_ban_for = 10
        assert_equal 10, UserSession.failed_login_ban_for
    
        UserSession.failed_login_ban_for 2.hours
        assert_equal 2.hours.to_i, UserSession.failed_login_ban_for
      end
    end
    
    class InstaceMethodsTest < ActiveSupport::TestCase
      def test_under_limit
        ben = users(:ben)
        ben.failed_login_count = UserSession.consecutive_failed_logins_limit - 1
        assert ben.save
        assert UserSession.create(:login => ben.login, :password => "benrocks")
      end

      def test_exceeded_limit
        ben = users(:ben)
        ben.failed_login_count = UserSession.consecutive_failed_logins_limit
        assert ben.save
        assert !UserSession.create(:login => ben.login, :password => "benrocks")
        assert !UserSession.create(ben)
        ben.updated_at = (UserSession.failed_login_ban_for + 2.hours.to_i).seconds.ago
        assert UserSession.create(ben)
      end
    
      def test_exceeding_failed_logins_limit
        UserSession.consecutive_failed_logins_limit = 2
        ben = users(:ben)
      
        2.times do |i|
          session = UserSession.new(:login => ben.login, :password => "badpassword1")
          assert !session.save
          assert session.errors.on(:password)
          assert_equal i + 1, ben.reload.failed_login_count
        end
      
        session = UserSession.new(:login => ben.login, :password => "badpassword2")
        assert !session.save
        assert !session.errors.on(:password)
        assert_equal 2, ben.reload.failed_login_count
      
        UserSession.consecutive_failed_logins_limit = 50
      end
    
      def test_resetting_failed_logins_count
        ben = users(:ben)
      
        2.times do |i|
          session = UserSession.new(:login => ben.login, :password => "badpassword")
          assert !session.save
          assert session.errors.on(:password)
          assert_equal i + 1, ben.reload.failed_login_count
        end
      
        session = UserSession.new(:login => ben.login, :password => "benrocks")
        assert session.save
        assert_equal 0, ben.reload.failed_login_count
      end
    end
  end
end