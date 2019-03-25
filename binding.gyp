{
  "targets": [
    {
      "target_name": "ext",
      "sources": [
        "ext/node-binding.cc",
        "ext/src/bitboard.c",
        "ext/src/bb_eval.c",
        "ext/src/bb_index.c",
        "ext/src/bb_endgame.c",
        "ext/src/bb_hash.c",
        "ext/src/bb_minimax.c",
        "ext/src/bb_uct.c",
        "ext/src/util.c"
      ],
      "include_dirs": ["<!(node -e \"require('nan')\")"]
    }
  ]
}

