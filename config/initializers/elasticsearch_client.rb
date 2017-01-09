if Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new host: '10.128.0.4'
else
  Elasticsearch::Model.client = Elasticsearch::Client.new log: true
end
