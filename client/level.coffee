class Level extends Backbone.View
  el: '#level'

  initialize: (@options) ->
    console.log @options
    @width = Math.floor @options.size
    @height = Math.floor (@options.size - @width) * 100

    @map = @options.data.replace(/\n/gm, '').split ''

    icons = {
      'a': 'wall', # S_WALL
      'X': 'empty', # STOP
      'k': 'empty', # RADIOACTIVE_FIELD
      '.': 'empty', # EMPTY_FIELD
      'R': 'robbo down', # ROBBO;
      'O': 'wall', # WALL
      'Q': 'wall red', # WALL_RED
      'T': 'screw', # SCREW
      '\'': 'bullet', # BULLET
      '#': 'box', # BOX
      '%': 'key', # KEY;
      'B': 'bomb purple', # BOMB2;  /* robbo alex has at least two types of bombs */
      'b': 'bomb', # BOMB;
      'D': 'door', # DOOR;
      '?': 'question', # QUESTIONMARK;
      '@': 'bear', # BEAR;
      '^': 'bird', # BIRD;
      '!': 'capsule', # CAPSULE;
      'H': 'ground', # GROUND;
      'o': 'wall green', # WALL_GREEN;
      '*': 'bear black', # BEAR_B;
      'V': 'butterfly', # BUTTERFLY;
      '&': 'teleport', # TELEPORT;
      '}': 'gun up', # GUN;
      'M': 'magnet', # MAGNET;
      '-': 'wall black', # BLACK_WALL;
      '~': 'box push', # PUSH_BOX;
      '=': 'barrier', # BARRIER;
      'q': 'wall fat', # FAT_WALL;
      'p': 'wall round', # ROUND_WALL;
      'P': 'wall boulder', # BOULDER_WALL;
      's': 'wall square', # SQUARE_WALL;
      'S': 'wall lattice', # LATTICE_WALL;
      '+': 'empty', # EMPTY_FIELD;
      'L': 'laser', # LASER_L;
      'l': 'laser', # LASER_D;
      ',': 'empty' # // This one must be additionally being resolved
    }

    _.each @map, (code, index) ->
      switch code
        when 'a' then icon = new Wall level: this                # S_WALL
        when 'R'
          icon = new Robbo level: this                           # ROBBO
          @robbo = icon
        when '.' then icon = new Empty level: this               # EMPTY
        when 'O' then icon = new Wall level: this                # WALL
        when 'Q' then icon = new Wall type: 'red'                # WALL_RED
        when '%' then icon = new Key level: this                 # KEY
        when '^' then icon = new Bird level: this                # BIRD
        when 'T' then icon = new Screw level: this               # SCREW
        when '?' then icon = new Question level: this            # QUESTIONMARK
        when '&' then icon = new Teleport level: this            # TELEPORT
        when 'b' then icon = new Bomb level: this                # BOMB
        when '}' then icon = new Gun level: this                 # GUN
        when 'V' then icon = new Butterfly level: this           # BUTTERFLY
        when 'H' then icon = new Ground level: this              # GROUND
        when 'D' then icon = new Door level: this                # DOOR
        when '@' then icon = new Bear level: this                # BEAR
        when '!' then icon = new Capsule level: this             # CAPSULE
        when '*' then icon = new Bear level: this, type: 'black' # BEAR_B
        when 'M' then icon = new Magnet level: this              # MAGNET
        when '#' then icon = new Box level: this                 # BOX
        when '~' then icon = new Box type: 'push'                # PUSH_BOX
        when '+' then icon = new Empty level: this               # EMPTY_FIELD
        when "'" then icon = new Bullet level: this              # BULLET
        when '=' then icon = new Barrier level: this             # BARRIER
        else throw '"unknown icon: ' + code + '"'

      @map[index] = icon
    , this

    setInterval =>
      $('.bear, .teleport, .bird, .butterfly').toggleClass 'animate-one'
      @act()
    , 200


    $(document).on 'keydown', (e) =>
      directions = '37': 'left', '38': 'up', '39': 'right', '40': 'down'
      direction = directions[e.keyCode ? e.which]
      if direction then @robbo.step(direction)

      marginTop = (5 - Math.floor(@robbo.$el.index() / @width))
      marginTop = 0 if marginTop > 0
      marginTop = (11 - @height) if marginTop  < 11 - @height

      @$el.css 'marginTop', marginTop * 32

  render: ->
    this.$el.css width: 32 * @width
    $('body').css background: '#' + @options.color

    _.each @map, (icon) ->
      @$el.append icon.$el
    , this

  act: ->
    _.each @map, (icon) ->
      icon.act()

  leftIcon: (icon) ->
    icon.$el.prev().data 'icon'

  rightIcon: (icon) ->
    icon.$el.next().data 'icon'

  upIcon: (icon) ->
    icon.$el.prevAll().eq(@width - 1).data 'icon'

  downIcon: (icon) ->
    icon.$el.nextAll().eq(@width - 1).data 'icon'


class LevelLoader
  constructor: (@name) ->
    $.get "levels/" + @name + ".dat", (@data) ->
      levels =  @data.match /\[offset\]([\s\S]*?)\[end\]/gi
      re = ///
        \[offset\]\n*([\s\S]*?)\n*
        \[level\]\n*([\s\S]*?)\n*
        \[colour\]\n*([\s\S]*?)\n*
        (\[level_notes\]\n*([\s\S]*?)\n*)?
        \[size\]\n*([\s\S]*?)\n*
        \[author\]\n*([\s\S]*?)\n*
        \[data\]\n*([\s\S]*?)\n*
        \[additional\]\n*([\s\S]*?)\n*
        \[end\]
      ///

      [ignore, offset, level, color, ignore, notes, size, author, data, additional] = levels[0].match re

      level = new Level({
        offset: offset,
        level: level,
        color: color,
        notes: notes,
        size: size,
        author: author,
        data: data,
        additional: additional
      })

      level.render()

