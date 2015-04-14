module Ruboty
  module Niconico
    module Actions
      class Niconico < Ruboty::Actions::Base
        NICOVIDEO_SEARCH_API_URL = "http://api.search.nicovideo.jp/api/snapshot/"

        def initialize(query, mode)
          @query = query
          @mode = mode
        end

        def post
          case @mode
          when :top
            video_url(response.first)
          when :rand
            video_url(response.sample)
          end
        end

        private

        def video_url(cmsid)
          'http://www.nicovideo.jp/watch/%s' % cmsid
        end

        def response
          uri = URI.parse(api_url)
          response = Net::HTTP.start(uri.host) do |http|
            http.open_timeout = 5
            http.read_timeout = 10
            http.post(uri.path, params.to_json)
          end
          response.body.scan(/\{"_rowid":.+?,"cmsid":".+?"\}/).map do | value |
            /\"cmsid\":\"(?<cmsid>.+)\"/ =~ value
            cmsid
          end
        end

        def connection
          Faraday.new do |connection|
            connection.request  :url_encoded
            connection.adapter  :net_http
            connection.response :json
          end
        end

        def api_url
          NICOVIDEO_SEARCH_API_URL
        end

        def params
          {
            query: @query,
            service: ["video"],
            search: ["title"],
            join: ["cmsid"],
            sort_by: "view_counter",
            size: 100,
            issuer: "ruboty-niconico"
          }
        end
      end
    end
  end
end
