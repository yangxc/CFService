require 'elasticsearch'
require 'json'
require 'hashie'

module ElasticPera

  # 根据传入的数据库及索引信息，索引数据库内容
  # database_info['driver'] 为数据库类型
  # database_info['username'] 为数据库用户名
  # database_info['password'] 为数据库用户对应的密码
  # database_info['table'] 为要建立索引的表
  # database_info['cols'] 为要建立索引的表中的字段数组
  # index_info['type'] 为要建立索引的类型
  # index_info['index'] 为目标索引
  def self.database_importor(database_info, index_info)

  end

  # 创建索引
  # index_info['index'] 要创建的索引名称
  def self.create_index(index_info)
    client = connectES
    type = index_info[:type] || 'default'
    client.index index: index_info[:index], type: type
  end

  # 索引一个文档
  # index_info['index'] 索引名称
  # index_info['type'] 索引类型
  # document 要索引文档的json表现形式
  def self.index_document(index_info, document)
    client = connectES
    client.index index: index_info[:index], type: index_info[:type], id: document[:id], body: document
  end

  def self.index_documents(index_info, documents)
  end

  # 查询指定的文档
  # index_info['index'] 索引名称
  # index_info['type'] 索引类型
  # query_info['query_type'] 索引类型
  # query_info['query_field'] 索引类型
  # query_info['query_value'] 索引类型
  # query_info['from'] 返回结果的开始位置
  # query_info['size'] 返回结果的大小
  def self.search(index_info, query_info)
    client = connectES
    response = client.search index: index_info[:index],
                             type: index_info[:type],
                             body: {
                                 query: { query_info[:query_type] => { query_info[:query_field] => query_info[:query_value]}},
                                 from: query_info[:from],
                                 size: query_info[:size]
                             }
    puts response['hits']['hits']

  end

  def self.update_document

  end

  def self.delete_document

  end

  def self.clear_index

  end

  def self.delete_index

  end


  # 创建elasticsearch客户端
  def self.connectES
    if defined? APP_CONFIG
      Elasticsearch::Client.new hosts: [{
        host: APP_CONFIG['elastic_info']['host'],
        port: APP_CONFIG['elastic_info']['port'],
        log: true,
        request_timeout: 5*60
      }]
    else
      Elasticsearch::Client.new hosts: [{
                                            host: 'localhost',
                                            port: 9200,
                                            log: true,
                                            request_timeout: 5*60
                                        }]
    end
  end

  # 基于传入参数形成待索引的文档
  def object_2_json(object)

  end

end