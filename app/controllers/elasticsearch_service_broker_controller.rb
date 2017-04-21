# -*- encode: utf-8 -*-

# 实现Elasticsearch的Service Broker
class ElasticsearchServiceBrokerController < ApplicationController

  #before_filter :authenticate

  # 实现服务目录
  # get '/v2/catalog'
  def catalog
    render json: APP_CONFIG['catalog']
  end

  # 服务创建
  # put /v2/service_instances/:instance_id
  def provision

  end

  # 服务绑定
  def binding

  end

  # 服务解绑
  def unbinding

  end

  # 服务删除
  def deprovisioning

  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "#{APP_CONFIG['basic_auth']['username']}" && password == "#{APP_CONFIG['basic_auth']['password']}"
    end
  end
end