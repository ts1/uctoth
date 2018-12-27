fs = require 'fs'
require './rejection_handler'
{readlines} = require './util'
{Board} = require './board'
{encode_normalized} = require './encode'

args = process.argv.slice 2
if args.length != 2
  process.stderr.write "Usage: #{process.argv[1]} nodes book.json\n"
  process.exit 1
[infile, outfile] = args
do ->
  book = {}
  await readlines infile, (line) ->
    [b, turn, value, n] = line.split(' ')
    n = parseInt(n)
    return if n < 100
    value = parseInt(value)
    b = new Board b
    code = encode_normalized(b)
    book[code] = {n, value}
  fs.writeFileSync outfile, JSON.stringify book
