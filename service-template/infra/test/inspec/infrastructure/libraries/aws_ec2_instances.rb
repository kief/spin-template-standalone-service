class AwsEc2Instances < Inspec.resource(1)
  name 'aws_ec2_instances'
  desc 'Verifies settings for a list of ec2 instances'
  example "
    describe aws_ec2_instances(state_name: 'running') do
      it { should have_instances }
      its('count') { should eq 1 }
      its('image_id') { should include 'ami-63b0341a' }
      its('name') { should include 'foo' }
    end
  "

  supports platform: 'aws'

  include AwsPluralResourceMixin

  filter = FilterTable.create
  filter.add_accessor(:where)
        .add_accessor(:entries)
        .add(:count)    { |x| x.entries.length }
        .add(:has_instances?)  { |x| !x.entries.empty? }
        .add(:states)   { |x| x.state.map { |s| s[:name] } }
        .add(:name)     { |x| 
          x.tags.flatten.select {|tag|
            tag[:key] == 'Name'
          }.map { |name_tag| name_tag[:value] }
        }

  # Pinched from https://github.com/trickyearlobe/inspec
  Aws::EC2::Types::Instance.members.each do |field|
    filter.add(field, field: field)
    define_method(field) do
      list.map(&:field)
    end
  end
  filter.connect(self, :table)

  def validate_params(raw_params)
    recognized_params = check_resource_param_names(
      raw_params: raw_params,
      allowed_params: [:name, :id, :state_name, :tag_value, :tag_values]
    )
    recognized_params
  end

  def to_s
    'List of EC2 Instances'
  end

  def fetch_from_api
    runner = BackendFactory.create(inspec_runner)
    instances = runner.fetch_instances(create_filters)[:reservations].map { |res| res.instances }.flatten
    @table = instances.map(&:to_h)
  end

  def create_filters
    filters = []
    filters << {name: 'tag:Name', values: [ @name ] } if defined? @name 
    filters << {name: 'instance-state-name', values: [ @state_name ] } if defined? @state_name
    if defined? @tag_value
      (tag_key,tag_value) = @tag_value.split(':')
      filters << { name: "tag:#{tag_key}", values: [ tag_value ] }
    end
    if defined? @tag_values
      @tag_values.each { |tagval|
        (tag_key,tag_value) = tagval.split(':')
        filters << { name: "tag:#{tag_key}", values: [ tag_value ] }
      }
    end
    filters
  end

  class Backend
    class AwsClientApi < AwsBackendBase
      BackendFactory.set_default_backend(self)
      self.aws_client_class = Aws::EC2::Client

      def fetch_instances(filters = {})
        aws_service_client.describe_instances(filters: filters)
      end
    end
  end

end
