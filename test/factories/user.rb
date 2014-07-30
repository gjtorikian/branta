Factory.define :user do |u|
  u.username 'factory%d'
  u.email    'factory%d@github.com'
  u.password 'whatever%d'
  u.token    'secrets%d'
end
