require 'spec_helper'
require 'awspec'
require 'aws-sdk'

def ec2_instances_named_in_deployment(deployment_identifier, name_tag)
  filters = [
    { name: 'instance-state-name', values: ['pending', 'running'] },
    { name: 'tag:DeploymentIdentifier', values: [deployment_identifier] },
    { name: 'tag:Name', values: [name_tag] }
  ]
  selected_ec2_instances(filters).map { |instance| 
    ec2(instance.instance_id)
  }
end

def ec2_instances_named(name_tag)
  filters = [
    { name: 'instance-state-name', values: ['pending', 'running', 'stopped' ] },
    { name: 'tag:Name', values: [name_tag] }
  ]
  selected_ec2_instances(filters).map { |instance| 
    ec2(instance.instance_id)
  }
end

def selected_ec2_instances(filters)
  response = ec2_client.describe_instances(filters: filters)
  if response.reservations.nil? || response.reservations.empty?
    []
  else
    response.reservations.map { |reservation| reservation.instances }.flatten
  end
end

def ec2_client
  Aws::EC2::Client.new(region: 'eu-west-1')
end

