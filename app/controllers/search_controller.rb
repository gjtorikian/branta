class SearchController < ApplicationController
  respond_to :html, :js, :xml, :json
  layout false

  def index
    per_page = ENV['BRANTA_PER_PAGE_COUNT'].to_i < 1 ? 25 : ENV['BRANTA_PER_PAGE_COUNT'].to_i
    page  = [ params[:page].to_i, 1 ].max
    sort  = params[:sort] || '_score'
    order  = params[:order] || 'desc'

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
            sort: [{sort.to_sym => {:order => order}}],
            size: per_page,
            from: per_page * ( page - 1 )
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
