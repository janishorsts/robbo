class Icon
  constructor: (options) ->
    @options = options ? {}
    @$el = $('<div></div>')
    @$el.data 'icon', this
    @cid = _.uniqueId('i')
    @initialize()
  initialize: ->
  act: ->
  touch: (direction) ->
  isEmpty: ->
    false
  swap: (dst) ->
    next = dst.$el.next()
    nextIcon = next.data 'icon'

    if nextIcon.cid == @cid
      dst.$el.before @$el
    else
      this.$el.before dst.$el
      next.before @$el

class Barrier extends Icon
  initialize: ->
    @$el.addClass 'barrier'

class Bear extends Icon
  initialize: ->
    @$el.addClass 'bear ' + (@options.type ? '')
    @direction = 'left'
  act: ->
    moves = {
      left:  ['down',  'left',  'up',    'right'],
      up:    ['left',  'up',    'right', 'down'],
      right: ['up',    'right', 'down',  'left'],
      down:  ['right', 'down',  'left',  'up']
    }

    direction = null

    _.every moves[@direction], (move) ->
      if @options.level[move + 'Icon'](this).isEmpty()
        direction = move
        return false
      true
    , this

    @direction = direction ? 'left'

    if direction then this.swap @options.level[direction + 'Icon'](this)


class Bird extends Icon
  initialize: ->
    @direction = 'down'
    @$el.addClass 'bird'
  act: ->
    up = @options.level.upIcon(this)
    down = @options.level.downIcon(this)

    if (@direction == 'down' and down.isEmpty()) or (@direction == 'up' and up.isEmpty() == false)
      @direction = 'down'
      if down.isEmpty() then this.swap down
    else if (@direction == 'down' and down.isEmpty() == false) or (@direction == 'up' and up.isEmpty())
      @direction = 'up'
      if up.isEmpty() then this.swap up

class Bomb extends Icon
  initialize: ->
    @$el.addClass 'bomb'
  touch: (direction) ->
    icon = @options.level[direction + 'Icon'](this)
    if icon.isEmpty()
      this.swap icon

class Box extends Icon
  initialize: ->
    @$el.addClass 'box'
  touch: (direction) ->
    icon = @options.level[direction + 'Icon'](this)
    if icon.isEmpty()
      this.swap icon

class Bullet extends Icon
  initialize: ->
    @$el.addClass 'bullet'

class Butterfly extends Icon
  initialize: ->
    @$el.addClass 'butterfly'

class Capsule extends Icon
  initialize: ->
    @$el.addClass 'capsule'

class Door extends Icon
  initialize: ->
    @$el.addClass 'door'

class Empty extends Icon
  initialize: ->
    @$el.addClass 'empty'
  isEmpty: ->
    true

class Ground extends Icon
  initialize: ->
    @$el.addClass 'ground'

class Gun extends Icon
  initialize: ->
    @$el.addClass 'gun up'

class Key extends Icon
  initialize: ->
    @$el.addClass 'key'
  touch: (direction) ->
    empty = new Empty
    @$el.before empty.$el
    @$el.remove()

class Magnet extends Icon
  initialize: ->
    @$el.addClass 'magnet left'

class Question extends Icon
  initialize: ->
    @$el.addClass 'question'

class Robbo extends Icon
  initialize: ->
    @$el.addClass 'robbo down'
  step: (direction) ->
    this.$el.removeClass('left right up down').addClass(direction).toggleClass('animate-one')
    icon = @options.level[direction + 'Icon'](this)
    if (icon.isEmpty())
      this.swap icon
    else
      icon.touch direction
      icon = @options.level[direction + 'Icon'](this)
      if icon.isEmpty() then this.swap icon

class Screw extends Icon
  initialize: ->
    @$el.addClass 'screw'
  touch: (direction) ->
    empty = new Empty
    @$el.before empty.$el
    @$el.remove()

class Teleport extends Icon
  initialize: ->
    @$el.addClass 'teleport'

class Wall extends Icon
  initialize: ->
    @$el.addClass 'wall ' + (@options.type ? '')
