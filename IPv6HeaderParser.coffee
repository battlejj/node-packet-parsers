translateProtocolNumber = require('.lib/TranslateProtocolNumber')
getBitsFromBytes = require('.lib/getBitsFromBytes')
HEX = 16

module.exports = exports = IPv6HeaderParser = (packet, offset) ->
  IPData =
    version: 6
    traffic_class: null
    dscp: null
    ecn: null
    flow_label: null
    payload_length: null
    next_header: null
    hop_limit: null
    source_ip: null
    destination_ip: null

  IPData.traffic_class = ((packet[offset] & 15) << 4) | (packet[offset + 1] >> 4)
  IPData.dscp = ((packet[offset] & 15) << 2) | (packet[offset + 1] >> 2)
  IPData.ecn = (packet[offset+1] >> 4) & 3
  IPData.flow_label =  ((packet[offset + 1] & 15) << 8) | (packet[offset + 2]) << 8 | packet[offset + 3]
  IPData.payload_length = packet.readUInt16BE(offset + 4)
  IPData.next_header = packet.readUInt8(offset + 6)
  IPData.protocol = IPData.next_header
  IPData.protocol_number = translateProtocolNumber(IPData.protocol)
  IPData.hop_limit = packet.readUInt8(offset + 7)
  IPData.source_ip = parseIPv6FromRange(packet, offset + 8)
  IPData.destination_ip = parseIPv6FromRange(packet, offset + 24)

  IPData


parseIPv6FromRange = (buffer, offset) ->
  ip = []
  for i in [offset .. offset + 15] by 2
    ip.push(buffer.readUInt16BE(i).toString(HEX))

  return ip.join(':')


