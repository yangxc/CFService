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
    result = create_index_helper instance_id,mapping
    if result.has_key? 'error'
      render status: :internal_server_error, message: result['error']['root_cause'][0]['reason']
    else
      render status: :created
    end
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
    # 设置要查找的索引和文档类型
    index_info = {:index=>params[:instance_id], :type=>params[:type]}
    doc = request.body.string
    response = index_document_helper index_info, doc
    if response['result'] = 'created' or response['result'] == 'updated'
      render status: :ok
    else
      render status: :internal_server_error
    end
  end

  # 查询文档
  def search
    # 设置要查找的索引和文档类型
    index_info = {:index=>params[:instance_id], :type=>params[:type]}
    # 设置查询条件
    query_info = {}
    # 设置查询类型
    query_info[:query_type] = params[:query_type] if params[:query_type]
    # 设置要查询的域
    query_info[:query_field] = params[:query_field] if params[:query_field]
    # 设置要查询的值
    query_info[:query_value] = params[:query_value] if params[:query_value]
    query_info[:from] = params[:from] || 0
    query_info[:size] = params[:size] || 10
    response = search_helper index_info, query_info
    if response['total'] == 0
      render status: 204
    else
      results = []
      response['hits'].each do |record|
        document = record['_source']
        document['id'] = record['_id']
        results.append document
      end
      puts results
      render json: results
    end
  end

  # 显示Elasticsearch基本信息
  def info
    elasticsearchInfo = Faraday.get @@ElasticsearchUri
    render json: elasticsearchInfo['body']
  end

  def analyze_field
    index_info = {:index=>params[:instance_id], :type=>params[:type]}
    query_info = {}
    query_info['query_value'] = params['query_value']
    query_info['query_field'] = params['query_field']
    puts analyze_field_helper index_info, query_info
  end

end
