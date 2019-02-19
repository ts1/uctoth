translations =
  en:
    first_move: 'First move'
    second_move: 'Second move'
    show_guide: 'Show guide'
    show_moves: 'Show record of moves'
    start: 'Start'
    undo: 'Undo'
    your_turn: 'Your turn.'
    thinking: 'Thinking...'
    you_pass: 'You have no moves.'
    pass: 'Pass'
    i_pass: 'I have no moves. Your turn.'
    win: 'You won by ${discs}!'
    lose: 'You lost by ${discs}!'
    draw: 'Draw!'
    play_again: 'Play Again'
    easiest: 'Very easy'
    easy: 'Easy'
    normal: 'Normal'
    hard: 'Hard'
    hardest: 'Very hard'
    mode: '${mode} mode'
    moves: 'Moves'
    invalid_moves: 'Incorrect moves.'
  ja:
    first_move: '先手'
    second_move: '後手'
    show_guide: 'ガイドを表示する'
    show_moves: '棋譜を表示する'
    start: 'スタート'
    undo: '待った'
    your_turn: 'あなたの番です。'
    thinking: '考えています...'
    you_pass: 'あなたの打てるところがありません。'
    pass: 'パス'
    i_pass: '私の打てるところがありません。あなたの番です。'
    win: '${discs}であなたの勝ちです!'
    lose: '${discs}であなたの負けです!'
    draw: '引き分け!'
    play_again: 'もう一度プレイする'
    easiest: '超イージー'
    easy: 'イージー'
    normal: 'ノーマル'
    hard: 'ハード'
    hardest: '超ハード'
    mode: '${mode}モード'
    moves: '棋譜'
    invalid_moves: '棋譜に誤りがあります'

lang = localStorage.uctoth_lang or
    window.navigator.languages?[0] or
    window.navigator.language or
    window.navigator.userLanguage or
    window.navigator.browserLanguage

lang = 'en' unless translations[lang]
translation = translations[lang]

module.exports = {
  t: translation
  lang
  expand: (name, params) ->
    text = @t[name]
    throw new Error 'no translation' unless text
    text.replace /\$\{(\w+)\}/g, (match, key) -> params[key]
  set: (lang) ->
    t = translations[lang]
    if t
      @lang = lang
      @t = t
      localStorage.uctoth_lang = lang
      history.replaceState null, '', '.' if window.history?.replaceState?
      document.querySelector('html').setAttribute('lang', lang)
}

