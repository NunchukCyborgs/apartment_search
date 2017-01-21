class ReviewCreatedNotificationJob

  def initialize(review_id)
    @review_id = review_id
  end

  def perform
    SlackNotificationService.new.post("Review ##{@review_id} is ready for approval.")
  end
end
