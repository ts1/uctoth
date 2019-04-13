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

Now most of CPU-consuming parts, endgame solving, game tree search and
learning, are also written in C.
They work as Node.js add-on and also as WebAssembly on browsers
(except learning).
CoffeeScript implementations still exist and used when add-on/wasm is not
available.

### Self learning

Starting from random plays, strengthens itself by loops of self playing and
machine learning.
Uses no existing records of games.

Included `weights.json` file is a result of learning ~100,000 self-played games.

### Game tree search

Employs modified *UCT search*.
Searches 15-25 plies deep maximum on modern JavaScript engines.
C version searches 30+ plies deep.
Beats my implementation of minimax with NegaScout by 70-80% winning rate.

### Static evaluation

Classic pattern-based evaluation method as described in publications by Michael Buro.
He is the god of computer Othello for me.

### Machine learning

Simple linear regression of ~57,000 sparse features per game position.
Optionally supports logistic regression, which predicts winning rate instead
of final score.
Now using mini-batch with AdaGrad for faster convergence.
Also written from scratch in CoffeeScript/C.

## Usage

First off run `yarn` to install dependencies and build Node add-on.

```
yarn
```

Most scripts expect `weights.json` file existing in this directory.
Copy from `ref` directory at first (then build your own).

```
cp ref/weights.json .
```

To run scripts written in CoffeeScript 2, you should either install
`coffeescript` globally, or use `npx coffee` to run.

### Bootstrapping

This section describes how to train your own `weights.json` from scratch.

First off, generate 1,000 randomly played games.

```
npx coffee selfplay-rnd -R -n 1000 -w 12 -f 10 -b 1000000 --min_col=0
```

They are random but the last 10 moves are perfectly played.
Generated games are stored in `book.db` (SQLite3 database).

Next, learn the generated games and make your first `weights.json`.

```
npx coffee learn
```

> If you can't use Node add-on for some reason, use `reg` instead.

Now you can remove `book.db` of random games.

```
rm book.db*
```

Copy `auto` script from `samples` directory.

```
cp samples/auto .
```

You may edit `auto` as you like.
Now you are ready to run automatic self-learning loop.

```
./auto
```

It runs regression and 30-game matches against `ref/weights.json`
every 1,000 games generated.
Match results are appended to `match.log`.

### Running self-play and learning in parallel

Running self-play and regression simultaneously can utilize multi-core CPUs,
thus can speed up the entire self learning process.

Sample scripts are in `samples` directory, copy them.

```
cp samples/selfplay-loop samples/reg-loop samples/match-loop .
```

Edit the scripts as you need.
Then run `reg-loop` in one terminal, `selfplay-loop` in another, and `match-loop` in the third.
This setup uses 3 CPU threads, but if it isn't enough for your machine,
you may run `selfplay-loop` as many as you want.

The trick is simple.
All selfplay scripts watch `weights.json` to change.
When `reg-loop` finished creating a new `weights.json`, selfplay scripts exit
and invoked again by shell script.

`watch` script is useful for watching to see if everything is working well.

### L2 parameter tuning

`learn` (and its CoffeeScript counter part `reg`/`minibatch`) uses
*L2 regularization* to avoid over-fitting.
It's important to give optimal parameters of this to build strong weights.

`l2tune` script is written for this purpose.
It uses K-fold cross-validation and optionally actually plays 30-game match to
find strongest parameters.
The result is written to `l2.json` and `learn` reads values from this file if
available.
It's recommended to run `l2tune` without `--match` periodically while learning,
and use `l2tune --match` for final finish of your `weights.json`.

> If Node add-on is not available, use `l2seach` and `l2opt` instead.

## Acknowledgement

Sound created by Nobuyuki Honda.

## License

MIT

Copyright © 2018-2019 by Takeshi Sone
