class SearchController < ApplicationController
  respond_to :html, :js, :xml, :json
  layout false

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def index
    per_page = 25
    if ENV['BRANTA_PER_PAGE_COUNT'].to_i > 0
      per_page = [ ENV['BRANTA_PER_PAGE_COUNT'].to_i, 50 ].min
    end

    page  = [ params[:page].to_i, 1 ].max
    sort  = params[:sort] || '_score'
    order  = params[:order] || 'desc'
    repo  = params[:repo] || nil
    path  = params[:path] || nil

    if repo.nil? && path.nil?
      query = {
            multi_match: {
              query: params[:q],
              fields: ['title^1', 'body']
            }
          }
    else
      query = {
        filtered: {
          query: {
            multi_match: {
              query: params[:q],
              fields: ['title^1', 'body']
            }
          },
          filter: {
            terms: {
            }
          }
        }
      }

      query[:filtered][:filter][:terms][:repo] = repo.split(",") if !repo.nil?
      query[:filtered][:filter][:terms][:repo] = path.split(",") if !path.nil?
    end

    assembled_query = { query: query,
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

    pages = Page.search(assembled_query)

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
                              :last_updated => page.attributes[:last_updated],
                              :last_indexed => page.attributes[:updated_at]
                            }
      end

      result[:total] = pages.total

      render :json => result
    end
  end

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'HEAD, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'HEAD, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
  end
end
