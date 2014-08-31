Factory.define :repository do |u|
  u.owner           'gjtorikian'
  u.name            'factory%d'
  u.name_with_owner 'gjtorikian/factory%d'
  u.hook_id         123456
end
