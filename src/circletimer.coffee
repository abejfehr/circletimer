# circletimer.coffee
#
# Heavily inspired by this StackOverflow answer:
# http://stackoverflow.com/questions/29649643/how-to-create-a-circular-countdown-timer-using-html-css-or-javascript
#
# @author Abe Fehr
#
$ = (window.jQuery || window.Zepto)

# An attempt to make this as cross-browser as possible
window.requestAnimFrame = do ->
  window.requestAnimationFrame or
  window.webkitRequestAnimationFrame or
  window.mozRequestAnimationFrame or
  (callback) ->
    window.setTimeout callback, 1000 / 60

# Methods for the actual plugin
methods =

  # Initializes the element with the circle timer
  #
  # @param [Object] options the options to use with the circle timer
  #
  init: (options) ->
    # Remove all the current contents
    this.empty()
    # Deal with the options given by the user
    defaults =
      timeout: 5000
      onComplete: (->)
      onUpdate: (->)
    data = {}
    data.options = $.extend defaults, options
    this.data "ct-meta", data
    # Generate the actual timer
    circle = document.createElementNS "http://www.w3.org/2000/svg", "circle"
    circle.setAttributeNS null, "r", "25%"
    circle.setAttributeNS null, "cx", "50%"
    circle.setAttributeNS null, "cy", "50%"
    circle.setAttributeNS null, "stroke-dasharray", "#{50 * Math.PI}%"
    svg = document.createElementNS "http://www.w3.org/2000/svg", "svg"
    svg.appendChild circle
    div = $ "<div></div>"
    div.attr "id", "ct-circle-container"
    div.append svg
    # Place the timer in the containing element
    this.append div

  # Starts the timer inside the element being called on
  #
  start: ->
    data = this.data("ct-meta")
    # If the timer had not already been going, initialize the timer-related data
    if not data.timeElapsed? or data.timeElapsed is data.options.timeout
      lastTimestamp = null
      data.timeElapsed = 0
    if data.reqId?
      window.cancelAnimationFrame data.reqId
    # Get a handle on the circle
    circle = $(this).find "circle"
    # What to accomplish during each animation frame
    step = (timestamp) ->
      if lastTimestamp? then data.timeElapsed += timestamp - lastTimestamp
      lastTimestamp = timestamp
      # Make the circle smaller by increasing the stroke's dashoffset
      circle.css "stroke-dashoffset",
      "#{50 * Math.PI * data.timeElapsed / data.options.timeout}%"
      if data.timeElapsed < data.options.timeout
        data.reqId = window.requestAnimationFrame(step)
        # Do the update for the user
        data.options.onUpdate(data.timeElapsed)
      else
        data.timeElapsed = data.options.timeout
        data.options.onUpdate(data.timeElapsed)
        data.options.onComplete()
    data.reqId = window.requestAnimationFrame(step)
    this.data "ct-meta", data

  # Stops the timer in the element being called on
  #
  stop: ->
    data = this.data "ct-meta"
    window.cancelAnimationFrame data.reqId
    data.timeElapsed = 0
    data.options.onUpdate(data.timeElapsed)
    this.data "ct-meta", data

  # Pauses the timer in the element being called on. The timer can be restarted
  #   again with "start"
  #
  pause: ->
    data = this.data "ct-meta"
    window.cancelAnimationFrame data.reqId
    this.data "ct-meta", data

  # Adds a given amount of time to the timer.
  #
  # @param [Number] added the number of milliseconds to add to the timer
  #
  add: (addend) ->
    data = this.data "ct-meta"
    if addend < data.timeElapsed
      data.timeElapsed -= addend
    else data.timeElapsed = 0
    this.data "ct-meta", data

# Add the methods to the element being called on
#
$.fn.circletimer = (methodOrOptions) ->
  if methods[methodOrOptions]
    return methods[methodOrOptions].apply this, Array::slice.call(arguments, 1)
  else if typeof methodOrOptions is "object" or not methodOrOptions
    # Default to "init"
    return methods.init.apply this, arguments
  else
    $.error "Method #{methodOrOptions} does not exist in circletimer!"