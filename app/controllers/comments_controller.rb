class CommentsController < ApplicationController
  before_action :require_login, :set_comment
  skip_before_action :set_comment, :only => [:index, :new, :create, :edit]

  def new
    if Destination.exists?(params[:destination_id])
      @destination = Destination.find_by(id: params[:destination_id])
      @comment = @destination.comments.build(user_id: current_user.id)
    else
      redirect_to destinations_path
    end
  end

  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to destination_path(comment.destination)
    else
      render 'new'
    end
  end

  def edit
    @destination = Destination.find_by(id: params[:destination_id])
    if @destination.nil?
      redirect_to destinations_path
    else
      @comment = @destination.comments.find_by(id: params[:id])
      redirect_to destination_path(@destination) if @comment.nil? || !verify(@comment)
    end
  end

  def update
    @comment.update(comment_params)
    my_path
  end

  def like
    @comment.like
    my_path
  end

  def dislike
    @comment.dislike
    my_path
  end

  private
    def comment_params
      params.require(:comment).permit(:user_id, :destination_id, :content)
    end

    def my_path
      set_comment
      redirect_to destination_path(@comment.destination)
    end
end
