# -*- encode: utf-8 -*-

require 'faraday'
require 'json'

# Elasticsearch的客户端程序
class ElasticsearchServiceClientController < ApplicationController

  # 创建索引
  # post /:instance_id/create_index
  # free 用户无法使用此操作
  def create_index
    instance_id = params[:instance_id]
    # todo: 需要判断planid是否可以执行此项操作
    mapping = nil
    if not request.body.string.blank?
      mapping = request.body.string
    end
    create_index_helper instance_id,mapping
    render status: :created
  end

  # 索引文档
  def index_document
    index_info = {:index=>params[:instance_id], :type=>params[:type]}
    doc = object_2_json params[:doc]

  end

  def search

  end

  # 显示Elasticsearch基本信息
  def info
    elasticsearchInfo = Faraday.get @@ElasticsearchUri
    render json: elasticsearchInfo['body']
  end

end
