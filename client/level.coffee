class Level extends Backbone.View
  el: '#level'

  initialize: (@options) ->
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
        when 'a' then icon = new Wall               # S_WALL
        when 'R' then icon = new Robbo              # ROBBO
        when '.' then icon = new Empty              # EMPTY
        when 'O' then icon = new Wall               # WALL
        when 'Q' then icon = new Wall type: 'red'   # WALL_RED
        when '%' then icon = new Key                # KEY
        when '^' then icon = new Bird               # BIRD
        when 'T' then icon = new Screw              # SCREW
        when '?' then icon = new Question           # QUESTIONMARK
        when '&' then icon = new Teleport           # TELEPORT
        when 'b' then icon = new Bomb               # BOMB
        when '}' then icon = new Gun                # GUN
        when 'V' then icon = new Butterfly          # BUTTERFLY
        when 'H' then icon = new Ground             # GROUND
        when 'D' then icon = new Door               # DOOR
        when '@' then icon = new Bear               # BEAR
        when '!' then icon = new Capsule            # CAPSULE
        when '*' then icon = new Bear type: 'black' # BEAR_B
        else throw '"unknown icon: ' + code + '"'

      @map[index] = icon
    , this

  render: ->
    this.$el.css width: 32 * @width
    $('body').css background: '#' + @options.color

    _.each @map, (icon) ->
      @$el.append icon.$el
    , this

  act: ->
    _.each @map, (icon) ->
      icon.act this
    , this

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
      ///


      [ignore, offset, level, color, ignore, notes, size, author, data, additional] = levels[1].match re

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



      setInterval ->
        $('.bear, .teleport, .robbo, .bird, .butterfly').toggleClass 'animate-one'
        level.act()
      , 250