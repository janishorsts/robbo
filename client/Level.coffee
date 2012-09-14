class Level
  constructor: (@options) ->
    console.log @options

    $('#level').css width: 32 * Math.floor @options.size
    $('body').css background: '#' + @options.color

    _.each @options.data.split(''), (code) ->
      map = {
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
      '}': 'gun', # GUN;
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

      $('#level').append '<div class="' + map[code] + '"></div>'

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


      [ignore, offset, level, color, ignore, notes, size, author, data, additional] = levels[19].match re

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

      setInterval ->
        $('.bear, .teleport, .capsule, .robbo, .butterfly').toggleClass 'animate-one'
      , 500