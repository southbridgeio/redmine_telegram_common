module TelegramCommon::Tdlib
  class Command
    def self.inherited(subclass)
      subclass.prepend Callable
    end

    def initialize(client)
      @client = client
    end

    module Callable
      def call(*)
        begin
          super
        ensure
          @client.close
        end
      end
    end
  end
end
