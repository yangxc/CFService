require 'elasticsearch'
require 'json'
require 'hashie'
require 'faraday'
module ApplicationHelper

  # 根据传入的数据库及索引信息，索引数据库内容
  # database_info['driver'] 为数据库类型
  # database_info['username'] 为数据库用户名
  # database_info['password'] 为数据库用户对应的密码
  # database_info['table'] 为要建立索引的表
  # database_info['cols'] 为要建立索引的表中的字段数组
  # index_info['type'] 为要建立索引的类型
  # index_info['index'] 为目标索引
  def database_importor(database_info, index_info)

  end

  # 创建索引
  # index_info['index'] 要创建的索引名称
  # mapping 创建索引的映射信息
  def create_index_helper(index, mapping = nil)
    conn = connectESByFarady elasticServerInfo
    response = nil
    # 创建索引
    unless mapping
      response = conn.put "/#{index}"
    else
      response = conn.put do |req|
        req.url "/#{index}"
        req.headers['Content-Type'] = 'application/json'
        req.body = mapping
      end
    end
    puts response.body
  end

  # 删除索引
  # index要创建的索引名称
  def delete_index(index)
    conn = connectESByFarady elasticServerInfo
    conn.delete "/#{index}"
  end

  # 索引一个文档
  # index_info['index'] 索引名称
  # index_info['type'] 索引类型
  # document 要索引文档的json表现形式
  def index_document_helper(index_info, document)
    client = connectES
    document_hash = str_2_json document
    document_id = document_hash.delete 'id'
    response = client.index index: index_info[:index], type: index_info[:type], id: document_id, body: document_hash
  end

  # 索引一批文档

  def self.index_documents(index_info, documents)
  end

  # 查询指定的文档
  # index_info['index'] 索引名称
  # index_info['type'] 索引类型
  # query_info['query_type'] 索引类型
  # query_info['query_field'] 要查询的字段
  # query_info['query_value'] 要查询的值
  # query_info['from'] 返回结果的开始位置
  # query_info['size'] 返回结果的大小
  def search_helper(index_info, query_info)
    client = connectES
    response = client.search index: index_info[:index],
                             type: index_info[:type],
                             body: {
                                 query: {query_info[:query_type] => {query_info[:query_field] => query_info[:query_value]}},
                                 from: query_info[:from],
                                 size: query_info[:size]
                             }
    puts response['hits']['hits'].class

  end

  # curl -XGET "http://localhost:9200/books/_analyze&field=title" -d "Elasticsearch Server"
  # 获取指定field的分析情况
  # index_info['index'] 索引名称
  # index_info['type'] 索引类型
  # query_info['query_field'] 要查询的字段
  # query_info['query_value'] 要查询的值
  def analyze_field(index_info, query_info)
    conn = connectESByFarady elasticServerInfo
    response = conn.get do |request|
      request.url "/#{index_info['index']}/_analyze"
      request.headers['Content-Type'] = 'text/plain;charset=utf-8'
      request.body = query_info['query_value']
      request.params['field'] = query_info['query_field']
    end
    puts response.body
  end

  def update_document

  end

  def delete_document

  end

  def clear_index

  end

  # 创建elasticsearch客户端
  def connectES
    Elasticsearch::Client.new host: "#{APP_CONFIG['elastic_info']['host']}:#{APP_CONFIG['elastic_info']['port']}", log: true
  end

  # 返回elastic search server基本信息
  def elasticServerInfo
    if defined? APP_CONFIG
      return {'host' => APP_CONFIG['elastic_info']['host'], 'port' => APP_CONFIG['elastic_info']['port']}
    else
      return {'host' => 'http://localhost', 'port' => 9200}
    end
  end

  # 基于传入参数形成待索引的文档
  def str_2_json(string)
    return JSON.parse string
  end

  def connectESByFarady(connectInfo)

    url = connectInfo['host'] + ':' + connectInfo['port'].to_s

    Faraday.new(:url => url) do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end

  end
=begin
# post payload as JSON instead of "www-form-urlencoded" encoding:
conn.post do |req|
  req.url '/nigiri'
  req.headers['Content-Type'] = 'application/json'
  req.body = '{ "name": "Unagi" }'
end
=end
end
