translateEthertype = require('.lib/TranslateEthertype')
getBitsFromBytes = require('.lib/getBitsFromBytes')
_ = require('underscore')
_.str = require('underscore.string')
_.mixin(_.str.exports())
VLAN_SERVICE_TAG = 34984
VLAN_CUSTOMER_TAG = 33024
HEX = 16

module.exports = exports = MACHeaderParser = (packet) ->
  MACData =
    source_MAC: []
    destination_MAC: []
    ethertype: ''
    service_VLAN_tagging: false
    service_VLAN_data:
      priority: null
      drop_eligible: null
      vlan_id: null
    VLAN_tagging: false
    VLAN_data:
      priority: null
      drop_eligible: null
      vlan_id: null
    payload_offset: null


  ###
  First 6 bytes of the header are the destination mac
  we have to pad with zeros before converting to
  hex aka base 16
  ###
  for i in [0..5] by 1
    MACData.destination_MAC.push(_.pad(packet[i].toString(HEX), 2, '0'))

  ###
  Second 6 bytes are the source mac
  ###
  for i in [6..11] by 1
    MACData.source_MAC.push(_.pad(packet[i].toString(HEX), 2, '0'))

  #turn the arrays into MAC address format strings
  MACData.destination_MAC = MACData.destination_MAC.join(':')
  MACData.source_MAC = MACData.source_MAC.join(':')

  ###
  determine if there is a vlan tag(s)
  first we have to check for service provider vlan tagging
  then we check for customer vlan tagging
  ###
  offset = 12

  #Service Provider VLAN Check
  #Determine if VLAN service tag value matches the next 2 byte int
  #if so there is service tagging
  if packet.readUInt16BE(offset) is VLAN_SERVICE_TAG
    #Yep service vlan tagged data
    #the actual vlan data is in the 2nd 2 bytes so these offsets are all +2 and +3
    MACData.service_VLAN_tagging = true
    MACData.service_VLAN_data.priority = packet[offset+2] >> 5 #get the first 3 bits
    MACData.service_VLAN_data.drop_eligible = (packet[offset+2] >> 4) & 1 #get the 4th bit
    MACData.service_VLAN_data.vlan_id = ((packet[offset+2] & 15) << 8) | packet[offset+3]#bits 5-16
    offset += 4 #the VLAN tags are 4bytes so increase offset by 4

  #Customer Provider VLAN Check
  #Determine if VLAN customer tag value matches the next 2 byte int
  #if so there is customer vlan tagging
  if packet.readUInt16BE(offset) is VLAN_CUSTOMER_TAG
    #Yep vlan tagged data
    #the actual vlan data is in the 2nd 2 bytes so these offsets are all +2 and +3
    MACData.VLAN_tagging = true
    MACData.VLAN_data.priority = packet[offset+2] >> 5 #get the first 3 bits
    MACData.VLAN_data.drop_eligible = (packet[offset+2] >> 4) & 1 #get the 4th bit
    MACData.VLAN_data.vlan_id_test = getBitsFromBytes(packet, offset+2, 4, offset+3, 7)
    #The hard way is below if getBitsFromBytes starts acting up
    #MACData.VLAN_data.vlan_id = ((packet[offset+2] & 15) << 8) | packet[offset+3]#bits 5-16
    offset += 4 #the VLAN tags are 4bytes so increase offset by 4

  MACData.ethertype = packet.readUInt16BE(offset)
  MACData.ethertype_description = translateEthertype(MACData.ethertype)

  MACData.payload_offset = offset += 2

  MACData
