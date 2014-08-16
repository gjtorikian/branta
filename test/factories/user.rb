require 'factory_girl'

Factory.define :user do |u|
  u.login 'factory%d'
  u.id     123
  u.token  "A" * 40
end
