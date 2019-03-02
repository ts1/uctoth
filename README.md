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

Starting from random plays, strengthens itself by loops of self playing and
machine learning.
Uses no existing records of games.

Included `scores.json` file is a result of ~~30 iterations of 1,000 self-plays
and learnings.
10 days work of a MacBook Pro.~~ 52,000 self-played games.

### Game tree search

Employs modified UCT search.
Searches 15-25 plies deep maximum on modern JavaScript engines.
Beats my implementation of minimax with NegaScout by 70-80% winning rate.

### Static evaluation

Classic pattern-based evaluation method as described in publications by Michael Buro.
He is the god of computer othello for me.

### Machine learning

Simple linear regression of 57,000+ sparse features per game position.
Now using AdaGrad for faster convergence.
Also written in CoffeeScript.

## Usage

Most scripts expect `scores.json` file existing in this directory.
Copy from `ref` directory at first (then build your own).

```
cp ref/scores.json .
```

To run scripts written in CoffeeScript 2, you should either install
`coffeescript` globally, or use `npx coffee` to run.

Node v10.x sometimes runs `regress` very slowly. I use v8.x.

### Bootstrapping

This section describes how to train your own `scores.json` from scratch.

First off, generate 1,000 randomly played games.

```
npx coffee selfplay-rnd -R -n 1000 -w 10 -f 8 -b 100000
```

They are random but the last 8 moves are perfectly played.
Generated games are stored in `book.db` (SQLite3 database).

Next, learn the generated games and make your first `scores.json`.

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

You may edit `auto` as you like.

Now you are ready to run automatic self-learning loop.

```
./auto
```

It runs regression and 30-game matches against `ref/scores.json`
every 1,000 games generated.
Match results are appended to `match.log`.

### Running self-play and learning in parallel

Running self-play and regression simultaneously can utilize multi-core CPUs,
thus can speed up the entire self learning process.
It's especially useful when the number of games grows large and regression takes
hours, and of course when you have idle CPU cores.

Sample scripts are in `samples` directory, copy them.

```
cp samples/selfplay-loop samples/reg-loop samples/match-loop .
```

Edit the scripts as you need.
Then run `reg-loop` in one terminal, `match-loop` in another, and
`selfplay-loop` in the third.
This setup uses 3 CPU threads, but if it isn't enough for your machine,
you may run `selfplay-loop` as many as you want.

The trick is simple.
All selfplay scripts watches `scores.json` to change.
When `reg-loop` finished creating a new `scores.json`, selfplay scripts exit
and invoked again by shell script.

`match-loop` also uses this feature, it plays games until `scores.json` is
updated.

`watch` script is useful for watching to see if all the system is working well.

## Acknowledgement

Sound created by Nobuyuki Honda.

## License

MIT

