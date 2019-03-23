{
  "targets": [
    {
      "target_name": "ext",
      "sources": [
        "node-binding.cc",
        "src/bitboard.c",
        "src/bb_eval.c",
        "src/bb_index.c",
        "src/bb_endgame.c",
        "src/bb_hash.c",
        "src/bb_minimax.c",
        "src/bb_uct.c",
        "src/util.c"
      ],
      "include_dirs": ["<!(node -e \"require('nan')\")"]
    }
  ]
}

