class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    @scan = Scan.find(params[:scan_id])
    @comment = current_user.comments.build(comment_params)
    @comment.scan = @scan
  
    respond_to do |format|
      if @comment.save
        format.html { redirect_to scan_path(@scan), notice: 'Commento aggiunto con successo!' }
        format.json { 
          html = render_to_string(partial: 'comments/comment', locals: { comment: @comment }, layout: false)
          render json: { 
            status: 'success', 
            message: 'Commento aggiunto con successo!',
            html: html 
          }
        }
      else
        format.html { redirect_to scan_path(@scan), alert: 'Errore nel salvare il commento.' }
        format.json { 
          render json: { 
            status: 'error', 
            message: 'Errore nel salvare il commento.' 
          }, 
          status: :unprocessable_entity 
        }
      end
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
      redirect_to scan_path(@comment.scan), notice: 'Commento aggiornato con successo!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    scan = @comment.scan
    @comment.destroy
    redirect_to scan_path(scan), notice: 'Commento eliminato con successo!'
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
    params.require(:comment).permit(:content, :scan_id)
  end

end
