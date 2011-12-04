class BoardsController < ApplicationController

  # Retreve board model before entering `show` or `sync` methods
  before_filter :set_board, only: [ :show, :sync ]

  # Authorize users before entering these methods
  before_filter :authorize, only: [ :show, :destroy, :sync ]

  def show
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(params[:board])
    if @board.save
      # Save board password in session
      
      # No security problem since session
      # is encrypted cookies by default.
      session[:password] = @board.password.hash

      # Redirect user to board, user should be able to
      # pass `authorize` method now.
      redirect_to @board
    else
      render action: 'new'
    end
  end

  def destroy
  end

  def login
    if request.post?
      unless @board = Board.find_by_name(params[:name])
        @login_error = 'No such whiteboard'
        return
      end

      if @board.password.hash == params[:password].hash
        # Password correct. Save it in session.
        session[:password] = params[:password].hash
        # Redirect user to board, user should be able to
        # pass `authorize` method now.
        redirect_to @board
      else
        @login_error = 'Incorrect password'
      end
    end
  end

  def sync
    # Logger will write too many things, disable it for a while.
    Rails.logger.silence do
      if request.post?
        # POST method means to write to board

        # Assuming writing successful
        result = true
        params.each do |k, v|
          if k.include? '_'
            # Get the position of text by split the key
            # key should look like `12_44`
            row, col = k.split('_').map(&:to_i)
            # Mark as failure if creating text failed
            result = false unless @board.texts.create(row: row, col: col, content: v)
          end
        end
        # Return status
        render text: result ? '1' : '0'
      else
        # GET method, read from board, return a json hash.
        texts = @board.read(params[:row], params[:col],
                            params[:height], params[:width])
        render json: texts.map { |t| [ t.row, t.col, t.content ] }
      end
    end
  end

  private

  def set_board
    # First look up by board name (for example, `public`).
    # Then fallback to id (an integer)
    @board = Board.find_by_name(params[:id]) || Board.find_by_id(params[:id])
  end

  def authorize
    return if @board.password.blank? or @board.password.hash == session[:password]
    # Authorize fails, redirect user to `login` page.
    render action: 'login'
  end
end
