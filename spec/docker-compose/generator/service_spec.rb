require 'helper.rb'

describe 'DockerCompose::Generator::Service' do
  let(:service) { DockerCompose::Generator::Service.new('rspec_test', 'test_image') }
  context 'environment' do
    it 'sets environment variable' do
      service.add_environment('test_env', 'value')
      expect(service).to be_has_environment('test_env')
    end

    it 'does not have environment variable' do
      expect(service).not_to be_has_environment('test_env')
    end

    it 'will drop environment variable' do
      expect(service.add_environment('test_env', 'value')).to eq('value')
      expect(service.drop_environment('test_env')).to eq('value')
      expect(service).not_to be_has_environment('test_env')
    end
  end

  context 'ports' do
    it 'sets ports variable with no target' do
      service.add_port('80')
      expect(service).to be_has_port('80')
    end

    it 'sets ports variable with target' do
      service.add_port('80', '8080')
      expect(service).to be_has_port('80', '8080')
    end

    it 'sets ports variable with target and type' do
      service.add_port('80', '8080', 'http')
      expect(service).to be_has_port('80', '8080', 'http')
    end

    it 'does not have ports variable' do
      expect(service).not_to be_has_port('9090')
    end

    it 'will drop ports variable' do
      service.add_port('80', '8080')
      service.drop_port('80', '8080')
      expect(service).not_to be_has_port('80', '8080')
    end
  end

  context 'links' do
    let(:link_service) { DockerCompose::Generator::Service.new('link_service', 'test_link_image') }
    it 'sets link variable without a name' do
      service.add_link(link_service)
      expect(service).to be_has_link(link_service)
    end

    it 'sets link variable with a custom link name' do
      service.add_link(link_service, 'my_custom_name')
      expect(service).to be_has_link(link_service, 'my_custom_name')
    end

    it 'does not have a link' do
      expect(service).not_to be_has_link(link_service)
    end

    it 'will drop link without custom name' do
      service.add_link(link_service)
      expect(service).to be_has_link(link_service)
      service.drop_link(link_service)
      expect(service).not_to be_has_link(link_service)
    end

    it 'will drop link with a custom name' do
      service.add_link(link_service, 'my_custom_name')
      expect(service).to be_has_link(link_service, 'my_custom_name')
      service.drop_link(link_service, 'my_custom_name')
      expect(service).not_to be_has_link(link_service, 'my_custom_name')
    end
  end
end
