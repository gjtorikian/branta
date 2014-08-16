# Mocks out warden github for controller tests.
class WardenMock

  def login(what)
    token = what.delete("token")
    user = Warden::GitHub::User.new what, token
    @user = user
    self
  end

  def user(scope = nil)
    @user
  end
end

module WardenHelpers
  def warden
    @wardenmock ||= WardenMock.new
  end
end
