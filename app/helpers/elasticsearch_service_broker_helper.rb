# 实现broker的辅助功能
require 'digest'

# 基于一定策略生成索引的名称
def generateIndexName(instance_id)
  Digest::MD5.hexdigest instance_id
end