class SlackNotificationService

  def initialize
    @notifier = Slack::Notifier.new "https://hooks.slack.com/services/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", channel: "#support", username: "Roomhere"
  end

  def post(message)
    @notifier.ping "#{message}  FROM #{Rails.env}"
  end
end
