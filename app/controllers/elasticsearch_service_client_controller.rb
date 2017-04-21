# -*- encode: utf-8 -*-

require 'faraday'

# Elasticsearch的客户端程序
class ElasticsearchServiceClientController < ApplicationController

  @@ElasticsearchUri = 'http://localhost:9200'
  def search

  end

  # 显示Elasticsearch基本信息
  def info
    elasticsearchInfo = Faraday.get @@ElasticsearchUri
    render json: elasticsearchInfo['body']
  end
end
