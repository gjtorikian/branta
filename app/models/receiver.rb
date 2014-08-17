class Receiver
  @queue = :events

  attr_accessor :event, :guid, :payload

  def initialize(event, guid, payload)
    @guid      = guid
    @event     = event
    @payload   = payload
  end

  def self.perform(event, guid, payload)
    receiver = new(event, guid, payload)
    unless receiver.active_repository?
      Rails.logger.info "Repository is not configured to deploy: #{receiver.full_name}"
    else
      receiver.run!
    end
  end

  def data
    @data ||= JSON.parse(payload)
  end

  def full_name
    data['repository'] && data['repository']['full_name']
  end

  def active_repository?
    if data['repository']
      name  = data['repository']['name']
      owner = data['repository']['owner']['login']
      repository = Repository.find_or_create_by(name: name, owner: owner)
      repository.active?
    else
      false
    end
  end

  def run!
    Resque.enqueue(Branta::Jobs::Index, guid, payload)
  end
end
