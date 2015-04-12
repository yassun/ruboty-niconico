require "ruboty/niconico/actions/niconico"

module Ruboty
  module Handlers
    class Niconico < Base
      on /niconico niconico/, name: 'niconico', description: 'TODO: write your description'

      def niconico(message)
        Ruboty::Niconico::Actions::Niconico.new(message).call
      end
    end
  end
end
