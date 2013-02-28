module.exports = exports = getBitsFromBytes = (buffer, startByte, startBit, endByte, endBit) ->
  ###
  We are assuming a 0 index for both bytes and bits
  if you arent getting the appropriate bits back
  ensure if you want bits 1-5 you have a startBit of 0
  and an end bit of 4. Same goes for bytes.
  ###
  returnBits = null
  unless Buffer.isBuffer(buffer)
    throw new Error('getBitsFromBytes expected a buffer but was not given one.')
  else

    if startByte is endByte
      returnBits = getBitsFromByte(buffer[startByte], startBit, endBit)
    else if startByte < endByte
      #crossing bytes
      #get the number of bytes in between the start and end byte
      midBytesLength = endByte - startByte - 1
      #get the necessary bits from the first byte
      returnBits = getBitsFromByte(buffer[startByte], startBit, 7)
      #for each middle byte shift in 8 0's and | the byte in
      for i in [1..midBytesLength] by 1
        returnBits = (returnBits << 8) | buffer[startByte + i]
      #shift 0's in for the last byte's bits and them in
      returnBits = returnBits << (endBit + 1) | getBitsFromByte(buffer[endByte], 0, endBit)
    else
      #we arent going backwards
      throw new Error('getBitsFromBytes expects the start byte to be smaller then the end byte')

  returnBits

getBitsFromByte = (byte, startBit, endBit) ->
  returnBits = null
  if startBit >= 0 and startBit < 8
    #only dealing with bits from 0 to 7
    if startBit is endBit
      #we are only getting one bit from the byte
      returnBits = if startBit < 7
      then byte >> startBit & (Math.pow(2, (7 - startBit)) - 1)
      else byte >> startBit
    else
      #we are getting a range of bits from the byte
      #if the start bit value is higher than the end bit, swap them
      if startBit > endBit
        tmp = startBit
        startBit = endBit
        endBit = tmp

      #shift off to the right to get our end bit as the last bit
      returnBits = byte >> (7 - endBit)
      #get rid of the bits we dont need a the beginning
      returnBits = returnBits & (Math.pow(2, (endBit - startBit + 1)) - 1)

  returnBits
