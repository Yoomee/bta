module PostsHelper

  def file_uploads? forum
    forum.allow_uploads == 1
  end

end
