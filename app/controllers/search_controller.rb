class SearchController < ApplicationController
  respond_to :html, :js, :xml, :json
  layout false

  PER_PAGE = 25

  def index
    page  = [ params[:page].to_i, 1 ].max
    query = { query: {
              multi_match: {
                query: params[:q],
                fields: ['title^1', 'body']
              }
            },
            highlight: {
              pre_tags: ['<span class="search-term">'],
              post_tags: ['</span>'],
              fields: {
                title: { number_of_fragments: 0 },
                path:  { number_of_fragments: 0 },
                body:  { fragment_size: 160 }
              }
            },
            size: PER_PAGE,
            from: PER_PAGE * ( page - 1 )
          }

    pages = Page.search(query)

    result = {}

    if pages.empty?
      render :json => result
    else
      result[:results] = []
      pages.each_with_hit do |page, hit|
        truncated_body = page.attributes[:body].length > 160 ? page.attributes[:body] + "…" : page.attributes[:body]
        result[:results] << {
                              :body => !hit.highlight.body.nil? ? hit.highlight.body.first : truncated_body,
                              :title => !hit.highlight.title.nil? ? hit.highlight.title.first : page.attributes[:title],
                              :path => page.attributes[:path],
                              :last_updated => page.attributes[:updated_at]
                            }
      end

      result[:total] = pages.total

      render :json => result
    end
  end
end
