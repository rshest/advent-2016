import os, strutils, sequtils, nre, tables, algorithm
  
proc computeChecksum(chars: string): string =
  var hist = initCountTable[char]()
  for c in chars: hist.inc(c)
  
  proc cmp(a, b: char): int =
    if hist[a] == hist[b]: return int(a) - int(b)
    return hist[b] - hist[a]  
  
  let res = sorted(toSeq(hist.keys), cmp)
  return res[0..4].join()

proc parseCode(code: string): (string, int, string) =
  let pattern = re"([a-z]+)(\d+)\[([a-z]+)\]"
  let parts = code.replace("-", "").find(pattern).get().captures
  (parts[0], parseInt(parts[1]), parts[2])

proc getSumRealRoomSectors(lines: seq[string]) : int =
  var sumSectors = 0
  for line in lines:
    let (chars, sectorId, checkSum) = parseCode(line)
    if computeChecksum(chars) == checkSum:
      sumSectors += sectorId
  return sumSectors

proc decodeChar(c: char, numRot: int): char =
  let numChar = int('z') - int('a') + 1
  return char((int(c) - int('a') + numRot) mod numChar + int('a'))

proc decrypt(code: string): (string, int) =
  let pattern = re"([a-z\-]+)-(\d+)\[[a-z]+\]"
  let parts = code.find(pattern).get().captures
  let encoded = parts[0]
  let id = parseInt(parts[1])

  iterator trans(str: string): string =
    for c in str:
      if c == '-': yield " "
      else: yield $decodeChar(c, id)
  
  return (toSeq(trans(encoded)).join(), id)

proc getIdOfEncryptedRoom(lines: seq[string], pattern: string) : int =
  for line in lines:
    let (text, id) = decrypt(line)
    if text.contains(pattern):
      return id
  return 0


let lines = toSeq(stdin.lines)

echo format("Sum of the sector IDs of the real rooms: $1", 
  getSumRealRoomSectors(lines))

echo format("Where North Pole objects are stored: $1", 
  getIdOfEncryptedRoom(lines, "object"))

