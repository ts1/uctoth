{
  "targets": [
    {
      "target_name": "ext",
      "sources": [
        "ext/node-binding.c",
        "ext/src/bitboard.c",
        "ext/src/bb_eval.c",
        "ext/src/bb_index.c",
        "ext/src/bb_endgame.c",
        "ext/src/bb_hash.c",
        "ext/src/bb_minimax.c",
        "ext/src/bb_uct.c",
        "ext/src/util.c"
      ],
      "include_dirs": ["include"]
    },
    {
      "target_name": "learn-ext",
      "sources": [
        "learn-ext/node-binding.c",
        "learn-ext/learn.c",
      ],
      "include_dirs": ["include"]
    }
  ]
}

