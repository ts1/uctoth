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
    win: 'You won by {}!'
    lose: 'You lost by {}!'
    draw: 'Draw!'
    play_again: 'Play Again'
  ja:
    first_move: '先手'
    second_move: '後手'
    show_guide: 'ガイドを表示する'
    start: 'スタート'
    undo: '待った'
    your_turn: 'あなたの番です'
    thinking: '考え中...'
    you_pass: 'あなたの打てる場所がありません'
    pass: 'パス'
    i_pass: '私の打てる場所がありません。あなたの番です'
    win: '${discs}であなたの勝ちです!'
    lose: '${discs}であなたの負けです!'
    draw: '引き分け!'
    play_again: 'もう一度プレイする'

lang = window.navigator.languages?[0] or
        window.navigator.language or
        window.navigator.userLanguage or
        window.navigator.browserLanguage

module.exports = table[lang] or table.en
