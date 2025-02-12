class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy, :vote]
  before_action :check_user, only: [:destroy]

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
    redirect_back(fallback_location: scan_path(scan), notice: 'Commento eliminato con successo!')
  end

  def vote
    vote_type = params[:vote_type]
    existing_vote = @comment.comment_votes.find_by(user: current_user)
  
    if existing_vote
      if existing_vote.vote_type == vote_type
        existing_vote.destroy
      else
        # Create a new vote instead of updating the existing one
        existing_vote.destroy
        @comment.comment_votes.create(user: current_user, vote_type: vote_type)
      end
    else
      @comment.comment_votes.create(user: current_user, vote_type: vote_type)
    end
  
    @comment.reload  # Add this line to ensure we have fresh data
  
    render json: {
      likes_count: @comment.likes_count,
      dislikes_count: @comment.dislikes_count,
      user_vote: @comment.vote_type_by(current_user)
    }
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
