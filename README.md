# Uctoth

Othello (Reversi) game engine written in CoffeeScript 2.
Demo page is [here](https://ts1.github.io/uctoth/).

## Experimental

This code is mostly experimental, not intended for reuse.
Reusing may need some work.
Read the source if you are interested.

## Features

### CoffeeScript 2

Works both on Node.js (with ES6+ features) and on [browsers](https://ts1.github.io/uctoth/) (with help from babel and webpack).

### Self learning

Starting from random plays, strengthens itself by a loop of self playing and
machine learning.
Uses no existing records of games.

Included `scores.json` file is a result of 30 iterations of 1,000 self-plays
and learnings.
10 days work of a MacBook Pro.

### Search algorithm

Employs modified UTC search.
Searches 15-25 plies deep maximum on modern JavaScript engines.
Beats my implementation of minimax by 70-80% winning rate.

### Static evaluation

Classic pattern-based evaluation method as described in publications by Michael Buro.
He is the god of computer othello for me.

### Machine learning

Simple linear regression of 57,000+ sparse features per position.
Also written in CoffeeScript.

## Usage

Most scripts expect `scores.json` file existing in this directory.
Copy from `ref` directory at first (then build your own).

```
cp ref/scores.json .
```

### Bootstrapping

This section describes how to train your own `scores.json`.

First off, generate 1,000 randomly played games.

```
./selfplay-rnd -R
```

They are random but endgame is perfectly played.
Generated games are stored in `book.db` (SQLite database).

Next, learn the generated games and make a new `scores.json`.

```
./reg
```

Now you can remove `book.db` of random games.

```
rm book.db*
```

Copy `auto` script from `samples` directory.

```
cp samples/auto .
```

You may want to edit `auto` and other scripts (especially constants) as you
like.

Now you are ready to run automatic self learning loop.

```
./auto
```

By default it runs regression and 30-game matches versus `ref/scores.json`
every 1,000 games generated.
Match results are appended to `match.log`.

## Acknowledgement

Sound created by Nobuyuki Honda.

## License

MIT

Copyright © 2018-2019 by Takeshi Sone
