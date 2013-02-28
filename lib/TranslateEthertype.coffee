sugar = require('sugar')
SupportedEthertypeNumbers =
  '2048': 'IPv4'
  '34525': 'IPv6'


module.exports = exports = (ethertypeNumber) ->
  if Object.has(SupportedEthertypeNumbers, ethertypeNumber)
    return SupportedEthertypeNumbers[ethertypeNumber]
  else
    return 'Unsupported ethertype'

