class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string  :owner,  :required => true, :nullable => false
      t.string  :name,   :required => true, :nullable => false
      t.boolean :active, :required => true, :default => true

      t.timestamps
    end

    add_column :pages_builds, :repository_id, :integer

    PagesBuild.all.each do |build|
      owner, name = build.name_with_owner.split('/')
      repository = Repository.find_or_create_by(owner: owner, name: name)
      build.repository = repository
      build.save
    end
  end
end
