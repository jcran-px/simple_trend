$:.unshift File.dirname(__FILE__)

###
### Check the models
###
require 'models/host'
require 'models/port'


###
### Finalize the models, check for errors
###
DataMapper.finalize