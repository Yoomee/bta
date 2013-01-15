MembersController.class_eval do
  def show
    @posts = @member.posts.latest.paginate(:page => params[:page])
  end
end