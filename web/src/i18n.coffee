table =
  en:
    first_move: 'First move'
    second_move: 'Second move'
    show_guide: 'Show guide'
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
    easiest: 'Easiest'
    easy: 'Easy'
    normal: 'Normal'
    hard: 'Hard'
    hardest: 'Hardest'
    mode: '${mode} mode'
  ja:
    first_move: '先手'
    second_move: '後手'
    show_guide: 'ガイドを表示する'
    start: 'スタート'
    undo: '待った'
    your_turn: 'あなたの番です'
    thinking: '考えています...'
    you_pass: 'あなたの打てるところがありません'
    pass: 'パス'
    i_pass: '私の打てるところがありません。あなたの番です'
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

parse_qs = (qs=window.location.search)->
  if qs[0] == '?'
    qs = qs.substr(1)
  result = {}
  for keyval in qs.split('&')
    [key, val] = keyval.split('=')
    key = decodeURIComponent(key)
    val = decodeURIComponent(val)
    result[key] = val
  result

params = parse_qs()
lang = params.lang
if lang
  localStorage._oth_lang = params.lang
else
  lang = localStorage._oth_lang or
      window.navigator.languages?[0] or
      window.navigator.language or
      window.navigator.userLanguage or
      window.navigator.browserLanguage

lang = 'en' unless table[lang]

module.exports = table[lang]
module.exports.lang = lang
