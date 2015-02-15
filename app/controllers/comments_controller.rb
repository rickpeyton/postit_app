class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit(:body))
    @comment.creator = current_user
    if @comment.save
      flash[:notice] = 'Your comment was saved'
      redirect_to post_path(@post)
    else
      flash[:danger] = 'You can not submit a blank comment'
      redirect_to :back
    end
  end

  def vote
    comment = Comment.find(params[:id])
    vote = Vote.create(vote: params[:vote],
                       creator: current_user,
                       voteable: comment)
    if vote.valid?
      flash[:notice] =
        "Your #{params[:vote] == 'true' ? 'up' : 'down'} vote was received"
    else
      flash[:danger] = 'You may only vote once per comment'
    end
    redirect_to :back
  end
end
