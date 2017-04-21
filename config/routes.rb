Rails.application.routes.draw do
  get '/v2/catalog', to: 'elasticsearch_service_broker#catalog'
  put '/v2/service_instances/:instance_id', to: 'elasticsearch_service_broker#provision'
  get '/v1/search/info', to: 'elasticsearch_service_client#info'
end
