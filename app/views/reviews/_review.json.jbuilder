json.extract! review, :id, :body, :title, :property_rating, :created_at, :updated_at, :landlord_rating, :landlord_comments, :duration, :approved_at
json.is_owned review.owned?(current_user)
json.is_anonymous review.anonymous?
if review.user_display_nickname && !review.anonymous?
  json.name review.user_display_nickname
end
if review.owned?(current_user)
  json.is_current_tenant review.current_tenant?
end
