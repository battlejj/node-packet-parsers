translateProtocolNumber = require('.lib/TranslateProtocolNumber')
getBitsFromBytes = require('.lib/getBitsFromBytes')
HEX = 16

module.exports = exports = IPv4HeaderParser = (packet, offset) ->
  IPData =
    version: null
    IHL: null
    DSCP: null
    ECN: null
    total_length: null
    identification: null
    flags: null
    fragment_offset: null
    ttl: null
    protocol: null
    header_checksum: null
    source_ip: []
    destination_ip: []
    options: null
    payload_offset: offset + 23

  ###
    version is the first 4 bits of first byte of the packet
  ###
  IPData.version = packet[offset] >> 4

  ###
   IHL is the second 4 bits of the first byte of the packet
  ###
  IPData.IHL = packet[offset] & 15

  ###
    DSCP is the first 6 bits of the 2nd byte of the packet
  ###
  IPData.DSCP = packet[offset + 1] >> 2

  ###
    ECN is the last 2 bits of the 2nd byte of the packet
  ###
  IPData.ECN = packet[offset + 1] & 3

  ###
    Total Length is bytes 3 and 4 of the packet
  ###
  IPData.total_length = packet.readUInt16BE(offset + 2)

  ###
    Identification is the 5th and 6th bytes of the packet
  ###
  IPData.identification = packet.readUInt16BE(offset + 4)

  ###
    Flags are the first 3 bits of the 7th byte of the packet
  ###
  IPData.flags = getBitsFromBytes(packet, offset + 6, 0, offset + 6, 2)
  #The hard way is below if getBitsFromBytes starts acting up
  #IPData.flags = packet[offset + 6] >> 5

  ###
    Fragment offset is the 4th bit of the 7th byte
    to the 8th bit of the 8th byte
  ###
  IPData.frag_offset = getBitsFromBytes(packet, offset + 6, 3, offset + 7, 7)
  #The hard way is below if getBitsFromBytes starts acting up
  #IPData.fragment_offset = ((packet[offset + 6] & 31) << 8) | packet[offset + 7]

  ###
    TTL is the 9th byte of the packet
  ###

  IPData.ttl = packet.readUInt8(offset + 8)

  ###
    protocol is the 10th byte of the packet
  ###
  IPData.protocol = packet.readUInt8(offset + 9)
  IPData.protocol_description = translateProtocolNumber(IPData.protocol)

  ###
    header checksum is 11th and 12th byte
  ###
  IPData.header_checksum = packet.readUInt16BE(offset + 10)

  ###
  source address is bytes 13-16
  ###
  IPData.source_ip = parseIPv4FromRange(packet,offset+12)

  ###
   destination address is bytes 17-20
  ###
  IPData.destination_ip = parseIPv4FromRange(packet,offset+16)

  IPData

parseIPv4FromRange = (buffer, offset) ->
  ip = []
  for i in [offset .. offset + 3] by 1
    ip.push(buffer[i])

  return ip.join('.')









