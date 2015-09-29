require 'helper'

describe 'DockerCompose::Generator' do
  let(:service_name) { 'test_service' }
  let(:service_image) { 'test_image' }
  let(:service) { DockerCompose::Generator.create_service(service_name, service_image) }
  context '#create_service' do
    it 'will return a Service object' do
      expect(service).to be_a(DockerCompose::Generator::Service)
    end
    it 'will have the correct name set' do
      expect(service.name).to eq(service_name)
    end

    it 'will have the correct image set' do
      expect(service.attrs['image']).to eq(service_image)
    end
  end

  context '#to_yaml' do
    it 'will generate correct yaml' do
      expect(DockerCompose::Generator.to_yaml).to eq("---\ntest_service:\n  image: test_image\n")
    end
  end

  context '#service?' do
    it 'will be false when no service exists' do
      expect(DockerCompose::Generator.service?('test')).to be_falsey
    end

    it 'will be trie when a service exists' do
      expect(DockerCompose::Generator.service?(service_name)).to be_truthy
    end

    context '#get_service' do
      it 'will be nil when on service exists' do
        expect(DockerCompose::Generator.get_service('test')).to be_nil
      end

      it 'will be a service when one exists' do
        srv = DockerCompose::Generator.create_service('test_spec', service_image)
        expect(DockerCompose::Generator.get_service('test_spec')).to eq(srv)
      end
    end
  end

  context '#import' do
    let(:file) { fixture('import1.yml') }

    before(:each) do
      DockerCompose::Generator.reset!
      DockerCompose::Generator.import(YAML.load(file))
    end

    it 'will create three items' do
      expect(DockerCompose::Generator.get_service('web')).to be_a(DockerCompose::Generator::Service)
      expect(DockerCompose::Generator.get_service('elastic')).to be_a(DockerCompose::Generator::Service)
      expect(DockerCompose::Generator.get_service('db')).to be_a(DockerCompose::Generator::Service)
    end

    it 'will return the same yaml after import' do
      expect(DockerCompose::Generator.to_yaml).to eq(fixture_read('import1.yml'))
    end
  end
end
