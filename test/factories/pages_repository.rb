Factory.define :pages_repository do |u|
  u.name_with_owner 'factory%d'
  u.hook_id    'factory%d@github.com'
end
