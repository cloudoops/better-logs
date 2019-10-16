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
#!/opt/puppetlabs/puppet/bin/ruby
################
# State Values #
################
# -5 => Pending; to be used in case of any failure
#  1 => Open; Never to be used
#  2 => Work in Progress; Never to be used
#  3 => Closed Complete; Only to be used upon successful run and validation
#  4 => Closed Failed; Never to be used
#  7 => Closed Skipped; Never to be used


require 'net/http'
require 'json'

# Service now login details are saved encrypted in inventory.yaml
params         = JSON.parse(STDIN.read)
require_relative '../../test/files/template.rb'
user           = params['_target']['user']
password       = params['_target']['password']
fqdn           = params['_target']['uri']
client_id      = params['client_id']
service_now_id = params['snid']
path     = '/api/now/table/change_request/'

#testing service_now_id = '1f7ac7e51b2bf740248786ae6e4bcb1a'


filename = File.basename(__FILE__).to_s
filename = filename[0..-4]


### Create your function here #####
command = Proc.new {
    Write-Content "I win!"
}

### Create your Error Message ####
# error = {} 

# # slave is initialized with parameters, which are handled by slave
kermit = Slave.new(params)

# # slave executes the commands and logs the results to splunk and returns a report to stdout
# # and writes a report onto the host in /var/bolt
report = kermit.execute(filename, command,error)
puts JSON.dump(report)
