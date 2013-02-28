translateProtocolNumber = require('.lib/TranslateProtocolNumber')
getBitsFromBytes = require('.lib/getBitsFromBytes')
HEX = 16

module.exports = exports = TCPHeaderParser = (packet, offset) ->
  TCPData =
    source_port: null
    destination_port: null
    sequence_number: null
    acknowledgement_number: null
    data_offset: null
    NS: null
    CWR: null
    ECE: null
    URG: null
    ACK: null
    PSH: null
    RST: null
    SYN: null
    FIN: null
    window_size: null
    checksum: null
    urgent_pointer: null
    options: null

  ###
    Source Port is the first 2 bytes of the header
  ###
  TCPData.source_port = packet.readUInt16BE(offset)

  ###
    Destination Port is the 3rd and 4th bytes of the header
  ###
  TCPData.destination_port = packet.readUInt16BE(offset + 2)

  ###
  Sequence Number is the 4th through 8th bytes
  ###
  TCPData.sequence_number = packet.readUInt32BE(offset + 4)

  ###
      Acknowledgement number is the 8th through 12th bytes
  ###
  TCPData.acknowledgement_number = packet.readUInt32BE(offset + 8)

  ###
    Data offset the first 4 bits of the 13th byte
  ###
  TCPData.data_offset = getBitsFromBytes(packet, offset + 12, 0, offset + 12, 3)

  ###
    NS is the 8th bit of the 13th byte
  ###
  TCPData.NS = getBitsFromBytes(packet, offset + 12, 7, offset + 12, 7)

  ###
    CWR is the 1st bit of the 14th byte
  ###
  TCPData.CWR = getBitsFromBytes(packet, offset + 13, 0, offset + 13, 0)

  ###
    ECE is the 2nd bit of the 14th byte
  ###
  TCPData.ECE = getBitsFromBytes(packet, offset + 13, 1, offset + 13, 1)

  ###
    URG is the 3rd bit of the 14th byte
  ###
  TCPData.URG = getBitsFromBytes(packet, offset + 13, 2, offset + 13, 2)

  ###
    ACK is the 4th bit of the 14th byte
  ###
  TCPData.ACK = getBitsFromBytes(packet, offset + 13, 3, offset + 13, 3)

  ###
    PSH is the 5th bit of the 14th byte
  ###
  TCPData.PSH = getBitsFromBytes(packet, offset + 13, 4, offset + 13, 4)

  ###
    RST is the 6th bit of the 14th byte
  ###
  TCPData.RST = getBitsFromBytes(packet, offset + 13, 5, offset + 13, 5)

  ###
    SYN is the 7th bit of the 14th byte
  ###
  TCPData.SYN = getBitsFromBytes(packet, offset + 13, 6, offset + 13, 6)

  ###
    FIN is the 8th bit of the 14th byte
  ###
  TCPData.FIN = getBitsFromBytes(packet, offset + 13, 7, offset + 13, 7)

  ###
    Window size is the 15th and 16th byte
  ###
  TCPData.window_size = packet.readUInt16BE(offset + 14)

  ###
    Checksum is the 17th and 18th byte
  ###
  TCPData.window_size = packet.readUInt16BE(offset + 16)

  ###
    Urgent Pointer is the 18th and 19th byte
  ###
  TCPData.window_size = packet.readUInt16BE(offset + 18)