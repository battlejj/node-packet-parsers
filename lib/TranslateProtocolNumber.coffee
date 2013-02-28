sugar = require('sugar')
SupportedIPProtocolNumbers =
  '1': 'ICMP'
  '2': 'IGMP'
  '4': 'IPv4'
  '6': 'TCP'
  '17': 'UDP'
  '41': 'IPv6'

module.exports = exports = (protocolNumber) ->
  if Object.has(SupportedIPProtocolNumbers, protocolNumber)
    return SupportedIPProtocolNumbers[protocolNumber]
  else
    return 'Unsupported protocol'

