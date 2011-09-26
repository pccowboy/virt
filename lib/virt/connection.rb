require 'libvirt'
module Virt
  class Connection
    attr_reader :connection

    def initialize uri
      raise("Must provide a guest to connect to") unless uri
      @connection = Libvirt::open_auth(uri, [Libvirt::CRED_AUTHNAME, Libvirt::CRED_PASSPHRASE]) do |cred|
        # This may only be required for ESXi connections, not sure.
        if cred['type'] == ::Libvirt::CRED_AUTHNAME
          res = SETTINGS[:esxi_username]
        elsif cred["type"] == ::Libvirt::CRED_PASSPHRASE
          res = SETTINGS[:esxi_password]
        else
          # cred type not supported
        end
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
