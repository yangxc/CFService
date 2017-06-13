# -*- encode: utf-8 -*-

require 'faraday'
require 'json'

# Elasticsearch的客户端程序
class ElasticsearchServiceClientController < ApplicationController

  # 创建索引
  # post /:instance_id/create_index
  # free 用户无法使用此操作
  # 参考索引文件：
  # {
  #     "mappings": {
  #         "fulltext": {
  #             "_all": {
  #                 "analyzer": "ik_max_word",
  #                 "search_analyzer": "ik_max_word",
  #                 "term_vector": "no",
  #                 "store": "false"
  #             },
  #             "properties": {
  #                 "title": {
  #                     "type": "text",
  #                     "analyzer": "ik_max_word",
  #                     "search_analyzer": "ik_max_word",
  #                     "include_in_all": "true",
  #                     "boost": 10
  #                 },
  #                 "content": {
  #                     "type": "text",
  #                     "analyzer": "ik_max_word",
  #                     "search_analyzer": "ik_max_word",
  #                     "include_in_all": "true",
  #                     "boost": 8
  #                 }
  #             }
  #         }
  #     }
  # }
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
  # 例子文档
  # {
  #   "id":5,
  #    "title":"文章标题",
  #    "content": "文章内容"
  # }
  #=end
  def index_document
    index_info = {:index=>params[:instance_id], :type=>params[:type]}
    doc = request.body.string
    index_document_helper index_info, doc
  end

  # 查询文档
  def search

  end

  # 显示Elasticsearch基本信息
  def info
    elasticsearchInfo = Faraday.get @@ElasticsearchUri
    render json: elasticsearchInfo['body']
  end

end
