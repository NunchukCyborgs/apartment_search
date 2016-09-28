json.extract! review, :id, :body, :title, :rating, :created_at, :updated_at
json.user review.user_email
json.url review_url(review, format: :json)
