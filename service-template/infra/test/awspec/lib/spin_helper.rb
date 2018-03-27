require 'ec2_helper'

def deployment_id
  ENV['DEPLOYMENT_ID']
end

def service
  ENV['SERVICE']
end

def component
  ENV['COMPONENT']
end

