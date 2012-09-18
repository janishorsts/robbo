class Icon extends Backbone.View
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
    @$el.data 'icon', this
    @$el.addClass 'bear ' + (@options.type ? '')
    @direction = 'left'
  act: (level) ->
    up = level.upIcon(this)
    down = level.downIcon(this)
    left = level.leftIcon(this)
    right = level.rightIcon(this)

    direction = null

    switch @direction
      when 'left'
        if down.isEmpty()
          direction = 'down'
        else if left.isEmpty()
          direction = 'left'
        else if up.isEmpty()
          direction = 'up'
        else if right.isEmpty()
          direction = 'right'
      when 'up'
        if left.isEmpty()
          direction = 'left'
        else if up.isEmpty()
          direction = 'up'
        else if right.isEmpty()
          direction = 'right'
        else if down.isEmpty()
          direction = 'down'
      when 'right'
        if up.isEmpty()
          direction = 'up'
        else if right.isEmpty()
          direction = 'right'
        else if down.isEmpty()
          direction = 'down'
        else if left.isEmpty()
          direction = 'left'
      when 'down'
        if right.isEmpty()
          direction = 'right'
        else if down.isEmpty()
          direction = 'down'
        else if left.isEmpty()
          direction = 'left'
        else if up.isEmpty()
          direction = 'up'

    switch direction
      when 'left' then empty = left
      when 'up' then empty = up
      when 'down' then empty = down
      when 'right' then empty = right

    @direction = direction ? 'left'

    if direction then this.swap empty


class Bird extends Icon
  initialize: ->
    @$el.data 'icon', this
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
    @$el.data 'icon', this
    @$el.addClass 'bomb'

class Butterfly extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'butterfly'

class Capsule extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'capsule'

class Door extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'door'

class Empty extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'empty'
  isEmpty: ->
    true

class Ground extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'ground'

class Gun extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'gun'

class Key extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'key'

class Question extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'question'

class Robbo extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'robbo up'
  up: ->
  down: ->
  left: ->
  right: ->

class Screw extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'screw'

class Teleport extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'teleport'

class Wall extends Icon
  initialize: ->
    @$el.data 'icon', this
    @$el.addClass 'wall ' + (@options.type ? '')

