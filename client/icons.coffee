class Icon
  constructor: (options) ->
    @options = options ? {}
    @$el = $('<div></div>')
    @$el.data 'icon', this
    @cid = _.uniqueId('i')
    @initialize()
  initialize: ->
  act: ->
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

class Bear extends Icon
  initialize: ->
    @$el.addClass 'bear ' + (@options.type ? '')
    @direction = 'left'
  act: (level) ->
    moves = {
      left:  ['down', 'left', 'up', 'right'],
      up:    ['left', 'up', 'right', 'down'],
      right: ['up', 'right', 'down', 'left'],
      down:  ['right', 'down', 'left', 'up']
    }

    direction = null

    directions = moves[@direction]

    _.every directions, (move) ->
      if level[move + 'Icon'](this).isEmpty()
        direction = move
        return false
      true
    , this

    @direction = direction ? 'left'

    if direction then this.swap level[direction + 'Icon'](this)


class Bird extends Icon
  initialize: ->
    @direction = 'down'
    @$el.addClass 'bird'
  act: (level) ->
    up = level.upIcon(this)
    down = level.downIcon(this)

    if (@direction == 'down' and down.isEmpty()) or (@direction == 'up' and up.isEmpty() == false)
      @direction = 'down'
      this.swap down
    else if (@direction == 'down' and down.isEmpty() == false) or (@direction == 'up' and up.isEmpty())
      @direction = 'up'
      this.swap up

class Bomb extends Icon
  initialize: ->
    @$el.addClass 'bomb'

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
    @$el.addClass 'gun'

class Key extends Icon
  initialize: ->
    @$el.addClass 'key'

class Question extends Icon
  initialize: ->
    @$el.addClass 'question'

class Robbo extends Icon
  initialize: ->
    @$el.addClass 'robbo up'
  up: ->
  down: ->
  left: ->
  right: ->

class Screw extends Icon
  initialize: ->
    @$el.addClass 'screw'

class Teleport extends Icon
  initialize: ->
    @$el.addClass 'teleport'

class Wall extends Icon
  initialize: ->
    @$el.addClass 'wall ' + (@options.type ? '')
