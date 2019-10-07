#!/opt/puppetlabs/puppet/bin/ruby
require 'net/http'
require 'json'

# Service now login details are saved encrypted in inventory.yaml
params         = JSON.parse(STDIN.read)
require_relative '../../test/files/template.rb'




##########################3
# Customize the code below
###########################

# customize parameters
# ex: user           = params['_target']['user']

### Create your function here #####
command =  {
  Write-Content "hello-World";
  
}
# ex: 'user' = user
result = {

}
### Create your Error Message ####
# ex: 'user' = user
error = { 
         
}
