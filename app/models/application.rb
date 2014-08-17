class Application

  def recent_pages_builds
    PagesBuilds.find(:all, :order => "id desc", :limit => 50)
  end

end
