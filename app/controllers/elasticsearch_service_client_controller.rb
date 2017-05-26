# -*- encode: utf-8 -*-

require 'faraday'

# Elasticsearch的客户端程序
class ElasticsearchServiceClientController < ApplicationController

  # 创建索引
  # post /:instance_id/create_index
  # free 用户无法使用此操作
  def create_index
    instance_id = params[:instance_id]
    # todo: 需要判断planid是否可以执行此项操作
    ElasticPera.create_index index:instance_id
    render json: {}
  end

  def index_document

  end

  def search

  end

  # 显示Elasticsearch基本信息
  def info
    elasticsearchInfo = Faraday.get @@ElasticsearchUri
    render json: elasticsearchInfo['body']
  end

end
