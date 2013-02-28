IPv4HeaderParser = require('./IPv4HeaderParser')
IPv6HeaderParser = require('./IPv6HeaderParser')

module.exports = exports = IPHeaderParser = (packet, offset) ->
  ###
    version is the first 4 bits of first byte of the packet
  ###
  version = packet[offset] >> 4

  if version is 4
    IPv4HeaderParser(packet, offset)
  else if version is 6
    IPv6HeaderParser(packet, offset)
  else
    console.log('This traffic is not IP traffic. No processing will be done.')


