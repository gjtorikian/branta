module Branta
  module Jobs
    class Index
      extend Resque::Plugins::LockTimeout

      @queue = :index
      @lock_timeout = Integer(ENV['INDEX_TIMEOUT'] || '300')

      # Only allow one index per-repo at a time
      def self.redis_lock_key(guid, payload)
        data = JSON.parse(payload)
        if payload = data['payload']
          if name = payload['name']
            return name
          end
        end
        guid
      end

      def self.identifier(guid, payload)
        redis_lock_key(guid, payload)
      end

      attr_accessor :guid, :payload

      def initialize(guid, payload)
        @guid      = guid
        @payload   = payload
      end

      def self.perform(guid, payload)

      end
    end
  end
end
