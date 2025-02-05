class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]  # Remove :edit and :update since they're not used
  before_action :check_user, only: [:destroy]   # Remove :edit and :update since they're not used

  def index
    @sort_column = params[:sort] || 'created_at'
    @sort_direction = params[:direction] || 'desc'

    @comments = current_user.comments
                          .joins(:scan)
                          .order(sort_query)
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

  def destroy
    scan = @comment.scan
    @comment.destroy
    redirect_to scan_path(scan), notice: 'Commento eliminato con successo!'
  end

  private

  def sort_query
    case @sort_column
    when 'file_name'
      Arel.sql("scans.file_name #{@sort_direction}")
    when 'created_at'
      { created_at: @sort_direction }
    else
      { created_at: :desc }
    end
  end

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
