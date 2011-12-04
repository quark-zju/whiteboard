#### What is Whiteboard?

# **Whiteboard** is a online service providing a place to write and
# share text.
# 
# A Whiteboard is similar to a very large plain paper, where texts can be
# written at any position in the paper.
#
# A public Whiteboard is a built-in board which everyone has full read and
# write access. Private boards can be created using links at the right
# corner.


##### Requirement

# Whiteboard requires a mordern browser. Firefox 4+ and Chrome 10+ are
# recommended.

#### Usage

##### See activities on the board by others

# The board is automatically updated, thus activities by others will be shown
# in realtime.
 
##### Write on the board
 
# Click at the board to put cursor at the position, then type what you want
# to write. Note that there is no support for complex characters such as 
# Chinese characters yet.
# 
# Green texts are texts not saved at the server. Once they turns black, they
# are saved in the server.
 
##### Erase texts from the board
 
# Just write spaces or use backspaces or use delete to remove texts from board.
 
##### Move across the board
 
# Just drag the board using mouse :)
#
# Append `#x,y` to the URL to move to a specified position. 

##### Create and log in a private board

# Use the 'Create' and 'Login' links at top right corner.

#### The Implementation

# **Whiteboard** is implemented in [Ruby][ru] using [Rails][ror]
# and hosted in [Heroko][he] cloud platform.

# [Rails][ror] is a MVC web framework suitable for
# [Test-driven development][tdd]. Whiteboard
# has fair tests for core models and controllers.

# Whiteboard's Code to Test Ratio is 1 : 1.0.

# At client side, Whiteboard use [HTML5 Canvas][ca] to draw texts, providing
# better performance than complex DOM elements.

#### The Source

# You are viewing the annotated sources of primary logical: models, some 
# controllers and unit / functional tests. Note that some logical
# in client side javascript is not presented here.

# To switch to view other
# source file, move your mouse to 'JUMP TO' at top right corner and
# select a source file.

# For full source, download it from

# Whiteboard source is authored by Wu Jun <<quark@cs.zju.edu.cn>> and 
# licensed under [Ruby License][rl].

# [ror]: http://rubyonrails.org/
# [ru]: http://www.ruby-lang.org/
# [tdd]: http://en.wikipedia.org/wiki/Test-driven_development
# [ca]: http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html
# [rl]: http://www.ruby-lang.org/en/LICENSE.txt
# [he]: http://www.heroku.com/

# * * *

# This is the routing configuration of Whiteboard.
Whiteboard::Application.routes.draw do

  # Routes for `/boards` URLs
  # Allowing `show`, `new`, `create` methods in Boards controller
  resources :boards, except: [ 'edit', 'update', 'index' ] do
    # Add custom methods for board members
    member do
      # Client-side will use AJAX to communite to server
      # via `sync` method.
      # `sync` method allows GET and POST http method
      # GET method for reading text data and POST method
      # for update server-side text data.
      match 'sync', via: [:get, :post]
    end
    # Custom methods for board collection
    collection do
      # `login` method to login private board
      match 'login', via: [:get, :post]
    end
  end

  # Route `/` to application controller's `root` method
  root to: 'application#root'
end
