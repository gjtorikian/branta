module Branta
  module Jobs
    class Index
      CONTENT_MATCHES = [
        'div[role="main"]',
        'div.content',
        'div.content-body',
        'body'
      ]

      extend Resque::Plugins::LockTimeout

      @queue = :index
      @lock_timeout = Integer(ENV['INDEX_TIMEOUT'] || '300')

      # Only allow one index per-repo at a time
      def self.redis_lock_key(guid, data, repository)
        if payload = data['payload']
          if name = payload['name']
            return name
          end
        end
        guid
      end

      def self.identifier(guid, payload, repository)
        redis_lock_key(guid, payload, repository)
      end

      attr_accessor :guid, :payload, :repository

      def self.name
        @payload["repository"]["name"]
      end

      def self.name_with_owner
        @payload['repository']['full_name']
      end

      def self.pusher
        @payload['build']['pusher']['login']
      end

      def self.sha
        @payload['build']['commit'][0..7]
      end

      def self.record
        PagesBuild.create(:status          => "built",
                          :guid            => @guid,
                          :name            => name,
                          :name_with_owner => name_with_owner,
                          :pusher          => pusher,
                          :sha             => sha,
                          :repository_id   => @repository["id"])
      end

      def self.perform(guid, payload, repository)
        @guid    = guid
        @payload = payload
        @repository = repository

        hash = { :id => "repository0",
                 :title => "page 0",
                 :body => "Collaboratively administrate empowered markets via plug-and-play networks. Dynamically procrastinate B2C users after installed base benefits. Dramatically visualize customer directed convergence without revolutionary ROI.",
                 :path => "/path/0/article"
                }

        Page.create hash

        # Dir.glob("**/*.html").map(&File.method(:realpath)).each do |html_file|
        #   relative_path = html_file.match(/#{repo}\/(.+)/)[1]
        #   html_file_contents = File.read(html_file)
        #
        #   # TODO: make these configurable?
        #   doc = Nokogiri::HTML(html_file_contents)
        #   next unless doc.css("meta[http-equiv='refresh']").empty?
        #
        #   title = doc.xpath("//title").text().strip
        #   last_updated = doc.xpath("//span[contains(concat(' ',normalize-space(@class),' '),'last-modified-at-date')]").text().strip
        #
        #   body = []
        #
        #   CONTENT_MATCHES.each do |content_selector|
        #     body += doc.css(content_selector)
        #     break if body.any?
        #   end
        #
        #   # convert from Nokogiri Element objects to strings
        #   body.map!(&:inner_text)
        #
        #   page = Page.new id: "#{repo}::#{relative_path}", title: title, body: body, path: relative_path, last_updated: last_updated
        #
        #   GitHubPagesSearch::repository.save(page)
        # end

        Page.gateway.refresh_index!
        record
      end
    end
  end
end
