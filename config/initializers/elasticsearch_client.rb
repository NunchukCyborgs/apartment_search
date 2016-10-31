if Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new host: 'search-es-prod-pxdox4tjiyhrua46eogkc7lvra.us-west-2.es.amazonaws.com'
else
  Elasticsearch::Model.client = Elasticsearch::Client.new log: true
end
