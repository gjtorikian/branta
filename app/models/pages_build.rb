class PagesBuild < ActiveRecord::Base
  validates_presence_of :name, :name_with_owner

  belongs_to :repository

  def self.latest_for_name_with_owner(name_with_owner)
    sets = self.select(:name, :status).
      where(:name_with_owner => name_with_owner).
      group("name, status")

    sets.map do |build|
      params = {
        :name            => build.name,
        :status          => build.status,
        :name_with_owner => name_with_owner
      }
      PagesBuild.where(params).order("created_at desc").limit(1)
    end.flatten
  end

  def payload
    @payload ||= JSON.parse(custom_payload)
  end

  def auto_deploy_payload(actor, sha)
    payload.merge(:actor => actor, :sha => sha)
  end
end
