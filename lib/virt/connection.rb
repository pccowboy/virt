require 'libvirt'
module Virt
  class Connection
    attr_reader :connection

    def initialize uri, options = {}
      raise("Must provide a host to connect to") unless uri 
      if options[:password] != nil then 
        @connection = Libvirt::open_auth(uri, [Libvirt::CRED_AUTHNAME, Libvirt::CRED_PASSPHRASE]) do |cred|
          # This may only be required for ESXi connections, not sure.
          if cred['type'] == ::Libvirt::CRED_AUTHNAME
            res = options[:username]
          elsif cred["type"] == ::Libvirt::CRED_PASSPHRASE
            res = options[:password]
          else
            # cred type not supported
          end
        end
      else 
        @connection = Libvirt::open uri
      end
    end

    def closed?
      connection.closed?
    end

    def secure?
      connection.encrypted?
    end

    def version
      connection.libversion
    end

    def disconnect
      connection.close
    end

    def host
      Host.new
    end

  end
end
