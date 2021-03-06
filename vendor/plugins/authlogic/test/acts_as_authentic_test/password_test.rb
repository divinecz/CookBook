require File.dirname(__FILE__) + '/../test_helper.rb'

module ActsAsAuthenticTest
  class PasswordTest < ActiveSupport::TestCase
    def test_crypted_password_field_config
      assert_equal :crypted_password, User.aaa_config.crypted_password_field
      assert_equal :crypted_password, Employee.aaa_config.crypted_password_field
      
      User.aaa_config.crypted_password_field = :nope
      assert_equal :nope, User.aaa_config.crypted_password_field
      User.aaa_config.crypted_password_field :crypted_password
      assert_equal :crypted_password, User.aaa_config.crypted_password_field
    end
    
    def test_password_salt_field_config
      assert_equal :password_salt, User.aaa_config.password_salt_field
      assert_equal :password_salt, Employee.aaa_config.password_salt_field
      
      User.aaa_config.password_salt_field = :nope
      assert_equal :nope, User.aaa_config.password_salt_field
      User.aaa_config.password_salt_field :password_salt
      assert_equal :password_salt, User.aaa_config.password_salt_field
    end
    
    def test_validate_password_field_config
      assert User.aaa_config.validate_password_field
      assert Employee.aaa_config.validate_password_field
      
      User.aaa_config.validate_password_field = false
      assert !User.aaa_config.validate_password_field
      User.aaa_config.validate_password_field true
      assert User.aaa_config.validate_password_field
    end
    
    def test_validates_confirmation_of_password_field_options_config
      default = {:minimum => 4, :if => "#{User.aaa_config.password_salt_field}_changed?".to_sym}
      assert_equal default, User.aaa_config.validates_confirmation_of_password_field_options
      assert_equal default, Employee.aaa_config.validates_confirmation_of_password_field_options
      
      User.aaa_config.validates_confirmation_of_password_field_options = {:yes => "no"}
      assert_equal({:yes => "no"}, User.aaa_config.validates_confirmation_of_password_field_options)
      User.aaa_config.validates_confirmation_of_password_field_options default
      assert_equal default, User.aaa_config.validates_confirmation_of_password_field_options
    end
    
    def test_validates_length_of_password_confirmation_field_options_config
      default = {:minimum => 4, :if => :require_password_confirmation?}
      assert_equal default, User.aaa_config.validates_length_of_password_confirmation_field_options
      assert_equal default, Employee.aaa_config.validates_length_of_password_confirmation_field_options
      
      User.aaa_config.validates_length_of_password_confirmation_field_options = {:yes => "no"}
      assert_equal({:yes => "no"}, User.aaa_config.validates_length_of_password_confirmation_field_options)
      User.aaa_config.validates_length_of_password_confirmation_field_options default
      assert_equal default, User.aaa_config.validates_length_of_password_confirmation_field_options
    end
    
    def test_crypto_provider_config
      assert_equal Authlogic::CryptoProviders::Sha512, User.aaa_config.crypto_provider
      assert_equal Authlogic::CryptoProviders::AES256, Employee.aaa_config.crypto_provider
      
      User.aaa_config.crypto_provider = Authlogic::CryptoProviders::BCrypt
      assert_equal Authlogic::CryptoProviders::BCrypt, User.aaa_config.crypto_provider
      User.aaa_config.crypto_provider Authlogic::CryptoProviders::Sha512
      assert_equal Authlogic::CryptoProviders::Sha512, User.aaa_config.crypto_provider
    end
    
    def test_transition_from_crypto_providers_config
      assert_equal [], User.aaa_config.transition_from_crypto_providers
      assert_equal [], Employee.aaa_config.transition_from_crypto_providers
      
      User.aaa_config.transition_from_crypto_providers = [Authlogic::CryptoProviders::BCrypt]
      assert_equal [Authlogic::CryptoProviders::BCrypt], User.aaa_config.transition_from_crypto_providers
      User.aaa_config.transition_from_crypto_providers []
      assert_equal [], User.aaa_config.transition_from_crypto_providers
    end
    
    def test_act_like_restful_authentication_config
      assert !User.aaa_config.act_like_restful_authentication
      assert !Employee.aaa_config.act_like_restful_authentication
      
      User.aaa_config.act_like_restful_authentication = true
      assert User.aaa_config.act_like_restful_authentication
      assert_equal Authlogic::CryptoProviders::Sha1, User.aaa_config.crypto_provider
      assert defined?(::REST_AUTH_SITE_KEY)
      assert_equal 1, Authlogic::CryptoProviders::Sha1.stretches

      User.aaa_config.act_like_restful_authentication false
      assert !User.aaa_config.act_like_restful_authentication
      
      User.aaa_config.crypto_provider = Authlogic::CryptoProviders::Sha512
      User.aaa_config.transition_from_crypto_providers = []
    end
    
    def test_transition_from_restful_authentication_config
      assert !User.aaa_config.transition_from_restful_authentication
      assert !Employee.aaa_config.transition_from_restful_authentication
      
      User.aaa_config.transition_from_restful_authentication = true
      assert User.aaa_config.transition_from_restful_authentication
      assert defined?(::REST_AUTH_SITE_KEY)
      assert_equal 1, Authlogic::CryptoProviders::Sha1.stretches
      
      User.aaa_config.transition_from_restful_authentication false
      assert !User.aaa_config.transition_from_restful_authentication
      
      User.aaa_config.crypto_provider = Authlogic::CryptoProviders::Sha512
      User.aaa_config.transition_from_crypto_providers = []
    end
    
    def test_validates_confirmation_of_password
      u = User.new
      u.password = "test"
      u.password_confirmation = "test2"
      assert !u.valid?
      assert u.errors.on(:password)
      
      u.password_confirmation = "test"
      assert !u.valid?
      assert !u.errors.on(:password)
    end
    
    def test_validates_length_of_password_confirmation
      u = User.new
      
      assert !u.valid?
      assert u.errors.on(:password_confirmation)
      
      u.password = "test"
      u.password_confirmation = ""
      assert !u.valid?
      assert u.errors.on(:password_confirmation)
      
      u.password_confirmation = "test"
      assert !u.valid?
      assert !u.errors.on(:password_confirmation)
      
      ben = users(:ben)
      assert ben.valid?
      
      ben.password = "newpass"
      assert !ben.valid?
      assert ben.errors.on(:password_confirmation)
      
      ben.password_confirmation = "newpass"
      assert ben.valid?
    end
    
    def test_password
      u = User.new
      old_password_salt = u.password_salt
      old_crypted_password = u.crypted_password
      u.password = "test"
      assert_not_equal old_password_salt, u.password_salt
      assert_not_equal old_crypted_password, u.crypted_password
    end
    
    def test_transitioning_password
      ben = users(:ben)
      transition_password_to(Authlogic::CryptoProviders::BCrypt, ben)
      transition_password_to(Authlogic::CryptoProviders::Sha1, ben, [Authlogic::CryptoProviders::Sha512, Authlogic::CryptoProviders::BCrypt])
      transition_password_to(Authlogic::CryptoProviders::Sha512, ben, [Authlogic::CryptoProviders::Sha1, Authlogic::CryptoProviders::BCrypt])
    end
    
    def test_reset_password
      ben = users(:ben)
      old_crypted_password = ben.crypted_password
      old_password_salt = ben.password_salt
      
      # soft reset
      ben.reset_password
      assert_not_equal old_crypted_password, ben.crypted_password
      assert_not_equal old_password_salt, ben.password_salt
      
      # make sure it didn't go into the db
      ben.reload
      assert_equal old_crypted_password, ben.crypted_password
      assert_equal old_password_salt, ben.password_salt
      
      # hard reset
      assert ben.reset_password!
      assert_not_equal old_crypted_password, ben.crypted_password
      assert_not_equal old_password_salt, ben.password_salt
      
      # make sure it did go into the db
      ben.reload
      assert_not_equal old_crypted_password, ben.crypted_password
      assert_not_equal old_password_salt, ben.password_salt
    end
    
    private
      def transition_password_to(crypto_provider, records, from_crypto_providers = Authlogic::CryptoProviders::Sha512)
        records = [records] unless records.is_a?(Array)
        User.acts_as_authentic do |c|
          c.crypto_provider = crypto_provider
          c.transition_from_crypto_providers = from_crypto_providers
        end
        records.each do |record|
          old_hash = record.crypted_password
          old_persistence_token = record.persistence_token
          assert record.valid_password?(password_for(record))
          assert_not_equal old_hash.to_s, record.crypted_password.to_s
          assert_not_equal old_persistence_token.to_s, record.persistence_token.to_s
          
          old_hash = record.crypted_password
          old_persistence_token = record.persistence_token
          assert record.valid_password?(password_for(record))
          assert_equal old_hash.to_s, record.crypted_password.to_s
          assert_equal old_persistence_token.to_s, record.persistence_token.to_s
        end
      end
  end
end