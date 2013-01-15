MembersController.class_eval do
  def show
    @posts = @member.posts.paginate(:page => params[:page])
  end
end