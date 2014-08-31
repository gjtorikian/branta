module Webhooks
  class AddView
    def initialize
    end

    def has_hook_to_branta?(repo_name)
      !Repository.find_by_name_with_owner(repo_name).nil?
    end
  end
end
