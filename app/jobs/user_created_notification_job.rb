class UserCreatedNotificationJob

  def initialize(user_id)
    @user_id = user_id
  end

  def perform
    user = User.find(@user_id)
    SlackNotificationService.new.post("New User Created #{user.email}. No other action is needed")
  end
end
