class Page
  include Elasticsearch::Persistence::Model

  index_name [Rails.application.engine_name, Rails.env].join('-')

  settings index: { number_of_shards: 1 }

  attribute :title, String, mapping: { analyzer: 'texty' }
  attribute :body,  String, mapping: { analyzer: 'texty' }
  attribute :path,  String

  validates :title, presence: true
  validates :body,  presence: true
  validates :path,  presence: true

  def to_param
    [id, name.parameterize].join('-')
  end
end
