require 'helper.rb'

describe 'DockerCompose::Generator::Service' do
  let(:service) { DockerCompose::Generator::Service.new('rspec_test', 'test_image') }

  shared_examples_for 'an array list' do
    let(:variable) { '' }
    context "array_list" do
      it 'sets the value' do
        service.send("add_#{variable}", 'test')
        expect(service.send("#{variable}?", 'test')).to be_truthy
      end
      it 'does not have a value' do
        expect(service.send("#{variable}?", 'test')).to be_falsey
      end
      it 'will drop the value' do
        service.send("add_#{variable}", 'test')
        expect(service.send("#{variable}?", 'test')).to be_truthy
        service.send("drop_#{variable}", 'test')
        expect(service.send("#{variable}?", 'test')).to be_falsey
      end
    end
  end

  [:expose, :volumes_from, :dns, :extra_hosts, :dns_search, :cap_add, :cap_drop, :env_file].each do |method|
    context "##{method}" do
      it_behaves_like 'an array list' do
        let(:variable) { "#{method}" }
      end
    end
  end

  shared_examples_for 'a single value' do
    let(:variable) { '' }
    context 'single value' do
      it 'sets the value' do
        service.send("#{variable}=", 'test')
        expect(service.send("#{variable}?")).to be_truthy
      end
      it 'does not have a value' do
        expect(service.send("#{variable}?")).to be_falsey
      end
    end
  end

  [:build, :dockerfile, :command, :working_dir, :entrypoint, :user, :hostname, :domainname, :mac_address,
   :mem_limit, :memswap_limit, :privileged, :restart, :stdin_open, :tty, :cpu_shares, :cpuset,
   :read_only, :volume_driver, :container_name].each do |method|
    context "##{method}" do
      it_behaves_like 'a single value' do
        let(:variable) { "#{method}" }
      end
    end
  end

  context '#image' do
    it 'allows changing the image' do
      expect(service.attrs['image']).to eq('test_image')
      service.image = 'new_image'
      expect(service.attrs['image']).to eq('new_image')
    end
  end


  context 'environment' do
    it 'sets environment variable' do
      service.add_environment('test_env', 'value')
      expect(service).to be_environment('test_env')
    end

    it 'does not have environment variable' do
      expect(service).not_to be_environment('test_env')
    end

    it 'will drop environment variable' do
      service.add_environment('test_env', 'value')
      expect(service).to be_environment('test_env')
      service.drop_environment('test_env')
      expect(service).not_to be_environment('test_env')
    end
  end

  context 'labels' do
    it 'sets labels variable' do
      service.add_label('com.test.label', 'value')
      expect(service).to be_label('com.test.label')
    end

    it 'does not have labels variable' do
      expect(service).not_to be_label('com.test.label')
    end

    it 'will drop labels variable' do
      service.add_label('com.test.label', 'value')
      expect(service).to be_label('com.test.label')
      service.drop_label('com.test.label')
      expect(service).not_to be_label('com.test.label')
    end
  end

  context 'ports' do
    it 'sets ports variable with no container port' do
      service.add_port('80')
      expect(service).to be_port('80')
    end

    it 'sets ports variable with container port' do
      service.add_port('80', '8080')
      expect(service).to be_port('80', '8080')
    end

    it 'does not have ports registered' do
      expect(service).not_to be_port('9090')
    end

    it 'will drop ports' do
      service.add_port('80', '8080')
      service.drop_port('80', '8080')
      expect(service).not_to be_port('80', '8080')
    end
  end

  context 'links' do
    shared_examples_for 'a link list' do
      let(:link) { DockerCompose::Generator::Service.new('link_service', 'test_link_image') }
      let(:attribute) { 'link' }

      context 'adds a link' do
        it 'sets link variable without a name' do
          service.send("add_#{attribute}", link)
          expect(service.send("#{attribute}?", link)).to be_truthy
        end

        it 'sets link variable with a custom link name' do
          service.send("add_#{attribute}", link, 'my_custom_name')
          expect(service.send("#{attribute}?", link, 'my_custom_name')).to be_truthy
        end
      end

      context 'does not have a link' do
        it 'does not have a link' do
          expect(service.send("#{attribute}?", link)).to be_falsey
        end

        it 'does not have a link with a custom_name' do
          service.send("add_#{attribute}", link)
          expect(service.send("#{attribute}?", link, 'my_custom_name')).to be_falsey
        end
      end

      context 'drops a link' do
        it 'will drop link without custom name' do
          service.send("add_#{attribute}", link)
          expect(service.send("#{attribute}?", link)).to be_truthy
          service.send("drop_#{attribute}", link)
          expect(service.send("#{attribute}?", link)).to be_falsey
        end

        it 'will drop link with a custom name' do
          service.send("add_#{attribute}", link, 'my_custom_name')
          expect(service.send("#{attribute}?", link, 'my_custom_name')).to be_truthy
          service.send("drop_#{attribute}", link, 'my_custom_name')
          expect(service.send("#{attribute}?", link, 'my_custom_name')).to be_falsey
        end
      end

    end

    it_behaves_like 'a link list'

    it_behaves_like 'a link list' do
      let(:attribute) { 'external_link' }
      let(:link) { 'my_external_link' }
    end

  end

  context '#net=' do
    %w(bridge none host container:name container:id).each do |item|
      it "sets net to #{item}" do
        expect(service.net=item).to eq(item)
      end
    end

    it 'sets deletes net when nil passed in' do
      expect(service.net='none').to eq('none')
      service.net=nil
      expect(service.attrs.include?('net')).to be_falsey
    end
  end

  context '#pid=' do
    it 'sets pid to host when true is passed in' do
      service.pid=true
      expect(service.attrs.include?('pid')).to be_truthy
      expect(service.attrs['pid']).to eq('host')
    end
    it 'does not set pid to host when non TrueClass passed in' do
      service.pid = 'test'
      expect(service.attrs.include?('pid')).to be_falsey
    end
  end

  context 'volumes' do
    it 'does not have volume registered' do
      expect(service).not_to be_volume('/dev/null')
    end

    shared_examples_for 'volumes' do
      let(:host) { '/dev/null' }
      let(:container) { nil }
      let(:mode) { nil }
      context 'add' do
        it 'adds volume' do
          service.add_volume(host, container, mode)
          expect(service).to be_volume(host, container, mode)
        end
      end
      context 'drops volume' do
        it 'will drop volume with container volume' do
          service.add_volume(host, container, mode)
          expect(service).to be_volume(host, container, mode)
          service.drop_volume(host, container, mode)
          expect(service).not_to be_volume(host, container, mode)
        end
      end
    end

    it_behaves_like 'volumes'
    it_behaves_like 'volumes' do
      let(:container) { '/dev/test' }
    end
    it_behaves_like 'volumes' do
      let(:container) { '/dev/test' }
      let(:mode) { 'ro' }
    end

  end
end
