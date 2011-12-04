# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


set_draggable = (element) ->
  element = jQuery(element)

  move = (event) ->
    if element.data("mouseMove")
      changeX = event.clientX - element.data("mouseX")
      changeY = event.clientY - element.data("mouseY")
      newX = parseInt(element.css("left")) + changeX
      newY = parseInt(element.css("top")) + changeY
      # element.css "left", newX
      # element.css "top", newY
      if Math.abs(changeX) + Math.abs(changeY) > 4
        element.data "mouseClick", false 
      document.trans_x += changeX
      document.trans_y += changeY
      document.board_row = -Math.floor(document.trans_y / document.char_height)
      document.board_col = -Math.floor(document.trans_x / document.char_width)
      element.data "mouseX", event.clientX
      element.data "mouseY", event.clientY
      # redraw
      document.plan_redraw()
      # update location hash, since it is slow to update window.location.hash
      # in Firefox, plan it in other place
      document.location_hash = "#" + document.board_row + "," + document.board_col
  
  element.mousedown (event) ->
    element.data "mouseMove", true
    # whether it is just a click without moving
    element.data "mouseClick", true
    element.data "mouseX", event.clientX
    element.data "mouseY", event.clientY
 
  element.parents(":last").mouseup (event) ->
    element.data "mouseMove", false
    if element.data('mouseClick')
      # set cursor position
      board = element[0]
      document.cursor_row = Math.round((event.clientY - parseInt(board.style.top) - document.trans_y) / document.char_height - .5)
      document.cursor_col = Math.round((event.clientX - parseInt(board.style.left) - document.trans_x) / document.char_width - .5)
      document.cursor_start_col = document.cursor_col
      # redraw
      document.plan_redraw()
  
  element.mouseout move
  element.mousemove move

document.location_hash_change = (hash) ->
  if hash != document.location_hash and hash.indexOf(',') > 0
    document.location_hash = hash
    [ document.board_row, document.board_col ] = (parseInt(x) for x in hash.replace(/^#/,'').split(','))
    document.trans_y = -document.board_row * document.char_height
    document.trans_x = -document.board_col * document.char_width
    document.plan_redraw()

document.redraw = ->
  board = $('#board')[0];
  ctx = board.getContext('2d')
  # clear
  ctx.clearRect(0,0,board.width,board.height)
  # translate
  ctx.save()
  ctx.translate(document.trans_x, document.trans_y)
  # draw texts
  ctx.fillStyle = "rgb(10,10,10)"
  for row, row_content of document.texts
    for col, content of row_content
      y = row * document.char_height
      x = col * document.char_width
      # since y is the bottom position, add a char_height here
      ctx.fillText(content, x, y + document.char_height - 4)
  # draw new_texts
  for row, row_content of document.new_texts
    for col, content of row_content
      y = row * document.char_height
      x = col * document.char_width
      ctx.fillStyle = "rgba(255,255,255,0.8)"
      ctx.fillRect x, y, document.char_width * content.length, document.char_height
      ctx.fillStyle = "rgb(78,154,6)"
      ctx.fillText(content, x, y + document.char_height - 4)
  # draw cursor
  y = document.char_height * document.cursor_row
  x = document.char_width * document.cursor_col
  ctx.fillStyle = 'rgba(95,143,194,0.4)'
  ctx.fillRect x, y, document.char_width, document.char_height

  ctx.restore()
  document.dirty = false
  true

document.update_hash = ->
  if document.location_hash != window.location.hash
    window.location.hash = document.location_hash
  document.update_hash_scheduled = false

document.plan_redraw = ->
  if document.dirty != true
    document.dirty = true
    window.setTimeout(document.redraw, 10)

document.plan_update_hash = ->
  if document.update_hash_scheduled != true
    document.update_hash_scheduled = true
    window.setTimeout(document.update_hash, 1000)

document.sync_upload = ->
  texts = {}
  for row, row_content of document.new_texts
    for col, content of row_content
      texts[row+'_'+col] = content

  $.ajax
    url: window.location.pathname + '/sync'
    type: 'POST'
    dataType: 'html'
    data: texts
    success: (data) ->
      if data.indexOf('1') > -1
        # remove from document.new_text
        for i, content of texts
          [ row, col ] = (parseInt(x) for x in i.split '_')
          if document.new_texts[row][col] == content
            delete document.new_texts[row][col]
            # add to document.texts
            if typeof(document.texts[row]) == 'undefined'
              document.texts[row] = { }
            document.texts[row][col] = content
            if $.isEmptyObject(document.new_texts[row])
              delete document.new_texts[row]
      true
    complete: ->
      document.sync_upload_sheduled = false
      # if there are something not commited, plan upload them
      if !$.isEmptyObject(document.new_texts)
        document.plan_sync_upload()
      true

document.sync_download = ->
  area =
    row: document.board_row
    col: document.board_col
    height: Math.floor($('#board').height() / document.char_height) + 2
    width: Math.floor($('#board').width() / document.char_width) + 2
  $.ajax 
    url: window.location.pathname + '/sync'
    data: area
    dataType: 'json'
    success: (data) ->
      # clean data in that area
      for row, row_content of document.texts
        if area.row <= row <= area.row + area.height
          for col of row_content
            if area.col <= col <= area.col + area.width
              # in range, remove it
              delete document.texts[row][col]
      # add back data
      for i in data
        [ row, col, content ] = i
        if typeof(document.texts[row]) == 'undefined'
          document.texts[row] = { }
        document.texts[row][col] = content
      # plan redraw
      document.plan_redraw()
      true
    complete: ->
      document.sync_download_sheduled = false
      document.plan_sync_download()
      true

document.plan_sync_upload = ->
  if document.sync_upload_sheduled != true
    document.sync_upload_sheduled = true
    window.setTimeout(document.sync_upload, 20)

document.plan_sync_download = ->
  if document.sync_download_sheduled != true
    document.sync_download_sheduled = true
    window.setTimeout(document.sync_download, 1000)

$(document).ready ->
  # center dialog or board
  calculation = (t) ->
    t = (if typeof t != "undefined" then t else 200)
    for i of { "#board":1, "#dialog":1 }
      j = $(i)
      if j.length > 0
        top = ($("body").height() - j.innerHeight()) / 2
        left = ($("body").width() - j.innerWidth()) / 2
        j.animate({ left: left + "px", top: top + "px", position: "absolute" } , t)
    true
  
  calculation 0
  $(window).resize calculation

  # if board exists, set draggable
  if $('#board').length > 0
    # bind drawing and mouse events to canvas
    ctx = $('#board')[0].getContext('2d')
    ctx.font = '20px Consolas, Courier New'
    document.char_width = ctx.measureText('X').width
    document.char_height = 20 # assuming

    # plan redraw
    document.dirty = false
    document.plan_redraw()
    document.plan_sync_download()

    # set it draggable
    set_draggable $('#board')

    # handle keypress event
    $('html').keypress (e) ->
      ch = String.fromCharCode(e.charCode)
      if 126 >= e.charCode >= 32
        # row
        if typeof(document.new_texts[document.cursor_row]) == 'undefined'
          document.new_texts[document.cursor_row] = { }
        # set ch at (row, col)
        document.new_texts[document.cursor_row][document.cursor_col] = ch
        document.cursor_col = document.cursor_col + 1
      document.plan_redraw()
      document.plan_sync_upload()
      true

    $('html').keydown (e) ->
      if e.keyCode == 13
        # enter
        document.cursor_col = document.cursor_start_col
        document.cursor_row = document.cursor_row + 1
      else if e.keyCode == 8
        # backspace
        document.cursor_col = document.cursor_col - 1
        if typeof(document.new_texts[document.cursor_row]) == 'undefined'
          document.new_texts[document.cursor_row] = { }
        # set ch at (row, col)
        document.new_texts[document.cursor_row][document.cursor_col] = ' '
        document.plan_sync_upload()
      else if e.keyCode == 38
        # up
        document.cursor_row = document.cursor_row - 1
      else if e.keyCode == 40
        # down
        document.cursor_row = document.cursor_row + 1
      else if e.keyCode == 37
        # left
        document.cursor_col = document.cursor_col - 1
        document.cursor_start_col = document.cursor_col
      else if e.keyCode == 39
        # right
        document.cursor_col = document.cursor_col + 1
        document.cursor_start_col = document.cursor_col
      document.plan_redraw()
      true

    # monitor hash changes
    document.location_hash_change window.location.hash
    window.onhashchange = ->
      document.location_hash_change window.location.hash
  # if board

# lefttop row, col in current view
# for requesting, are trans_x / char_width, trans_y / char_height
document.board_row = 0
document.board_col = 0
# trans x, y (in pixel)
document.trans_x = 0
document.trans_y = 0
# char size (in pixel)
document.char_width = 12
document.char_height = 20
# cursor position
document.cursor_row = 0
document.cursor_col = 0 
document.cursor_start_col = 0
# texts
document.texts = { 0: { 0: 'Loading...' }  }
# new texts, waiting for commiting
document.new_texts = { }
  
# vim: set ts=2 sw=2 et:
