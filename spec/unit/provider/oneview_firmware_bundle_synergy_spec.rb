################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require 'spec_helper'

provider_class = Puppet::Type.type(:oneview_firmware_bundle).provider(:synergy)
api_version = login[:api_version] || 200
resource_type = OneviewSDK.resource_named(:FirmwareBundle, api_version, :Synergy)
firmware_driver_class = OneviewSDK.resource_named(:FirmwareDriver, api_version, :Synergy)

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_firmware_bundle).new(
      name: 'firmware_bundle',
      ensure: 'present',
      data:
          {
            'resourceId'           => 'test_firmware_bundle',
            'firmware_bundle_path' => './spec/support/test_firmware_bundle.spp'
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:test_resource) { firmware_driver_class.new(@client, resource['data']) }

  it 'should be an instance of the provider synergy' do
    expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_firmware_bundle).provider(:synergy)
  end

  context 'given the minimum parameters' do
    before(:each) do
      allow(firmware_driver_class).to receive(:get_all).and_return([test_resource])
      provider.exists?
    end

    it 'should raise error when firmware bundle is not found' do
      expect { provider.found }.to raise_error(/"Found" is not a valid ensurable for firmware bundle./)
    end

    it 'should raise an error since the destroy operation is not supported' do
      expect { provider.destroy }.to raise_error(/"Absent" is not a valid ensurable for firmware bundle./)
    end
  end

  context 'given the present action' do
    it 'should create/add the firmware bundle' do
      expect(firmware_driver_class).to receive(:get_all).and_return([])
      expect(resource_type).to receive(:add).and_return(test_resource)
      provider.exists?
      expect(provider.create).to be
    end
  end
end
