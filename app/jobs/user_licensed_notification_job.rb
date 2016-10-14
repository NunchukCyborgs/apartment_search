class UserLicensedNotificationJob

  def initialize(user_id, license_id)
    @license_id = license_id
    @user_id = user_id
  end

  def perform
    user = User.find(@user_id)
    license = License.find(@license_id)
    SlackNotificationService.new.post("New User License Request #{user.email}. Verification Needed for license: #{license.value}")
  end
end
