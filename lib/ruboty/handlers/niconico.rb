require "ruboty/niconico/actions/niconico"

module Ruboty
  module Handlers
    class Niconico < Base
      on /nico (?<mode>.+?) (?<keyword>.+)/, name: 'niconico', description: 'Search from nicovideo'

      def niconico(message)
        if url = search(message[:keyword], message[:mode].to_sym)
          message.reply(url)
        end
      end

      private

      def search(query, mode)
        Ruboty::Niconico::Actions::Niconico.new(query, mode).post
      end
    end
  end
end
