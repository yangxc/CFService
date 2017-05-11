Rails.application.routes.draw do
  # 提供服务清单
  get '/v2/catalog', to: 'elasticsearch_service_broker#catalog'
  # 提供服务供应
  put '/v2/service_instances/:instance_id', to: 'elasticsearch_service_broker#provision'
  # 提供服务绑定
  PUT '/v2/service_instances/:instance_id/service_bindings/:binding_id', to:'elasticsearch_service_broker#bind'
  # 提供服务解绑
  DELETE '/v2/service_instances/:instance_id/service_bindings/:binding_id', to:'elasticsearch_service_broker#unbinding'
  # 取消服务提供
  DELETE '/v2/service_instances/:instance_id', to:'elasticsearch_service_broker#deprovisioning'
  # 获取Elasticsearch Server的基本状态信息
  get '/v1/search/info', to: 'elasticsearch_service_client#info'
end
