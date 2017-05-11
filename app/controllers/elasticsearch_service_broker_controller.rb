# -*- encode: utf-8 -*-

# 实现Elasticsearch的Service Broker
class ElasticsearchServiceBrokerController < ApplicationController

  #before_filter :authenticate

  # 实现服务目录
  # get '/v2/catalog'
  def catalog
    render json: APP_CONFIG['catalog']
  end

  # 服务供应
  # 服务计划分为三种：
  # free（只能在给定的索引上进行操作，不允许对索引进行CRUB）
  # media（能对索引进行CRUB，但不能指定备份等策略）
  # advance（全部放开）
  # put /v2/service_instances/:instance_id
  def provision
    # 基于instance_id创建一个单独的索引
    #free在es实现安全的前提下，创建用户名和密码，现在只是基于instance_id创建索引
    instance_id = params[:instance_id]
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