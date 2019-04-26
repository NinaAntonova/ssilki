class CollaborationsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # load_and_authorize_resource
  before_action :set_collaboration, only: [:show, :edit, :update, :destroy]

  def create
    @board = board.find(params[:board_id])
    @user = User.where('username LIKE ?', "%#{params[:search]}%")
              .all_except(current_user)
              .exclude_collaborators(@board)
              .first
    if @user
      @collaboration = Collaboration.new(board: @board, user: @user)
      if @collaboration.save
        flash[:notice] = "User successfully added to wiki."
      else
        flash[:error] = "There was a problem adding user. Please try again."
      end
    else
      flash[:error] = "Sorry that wasn't a valid username. Please try again."
    end
    redirect_to @board
  end
