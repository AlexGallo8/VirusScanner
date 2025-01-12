class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    if @comment.save
      redirect_to comments_path, notice: 'Commento creato con successo!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @comments = Comment.all.order(created_at: :desc)
    # oppure se vuoi la paginazione:
    # @comments = Comment.all.order(created_at: :desc).page(params[:page])
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to comments_path, notice: 'Commento aggiornato con successo!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to comments_path, notice: 'Commento eliminato con successo!'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def check_user
    unless @comment.user == current_user
      redirect_to comments_path, alert: 'Non sei autorizzato a modificare questo commento.'
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
