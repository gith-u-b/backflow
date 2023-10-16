require 'ipdb'
module Ipnet

  class << self

    def find_by_ip(ip)
      if ip.split(",").size > 1
        result = nil
      else
        result = ipv4_database.find(ip)
      end
      return { country: '', province: '', city: '', area: '' } if !result.present?
      result
    end

    def ipv4_database(data_file = nil)
      @ipv4_database ||= IPv4Database.new(data_file)
    end

  end

  class IPv4Database

    DEFAULT_DATA_FILE = File.expand_path("../../data/mydata4vipday3_cn.ipdb", __FILE__)

    def initialize(data_file = nil)
      @data_file = data_file || DEFAULT_DATA_FILE
      @db = IPDB.city(DEFAULT_DATA_FILE)
    end

    def find(ip)
      data = @db.find(ip, "CN")
      return {country: data[0], province: data[1], city: data[2], area: data[4]}
    end
  end

end
