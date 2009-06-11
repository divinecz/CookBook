class UserObserver < ActiveRecord::Observer
  def after_create(user)
    # PostOffice.deliver_registration(user)
  end
end