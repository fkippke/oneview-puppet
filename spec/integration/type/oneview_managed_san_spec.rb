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

type_class = Puppet::Type.type(:oneview_managed_san)

def managed_san_config
  {
    name: 'managed_san_1',
    ensure: 'present',
    data:
    {
      'name' => 'SAN1_0',
      'publicAttributes' => {
        'name' => 'MetaSan',
        'value' => 'Neon SAN',
        'valueType' => 'String',
        'valueFormat' => 'None'
      },
      'sanPolicy' => {
        'zoningPolicy' => 'SingleInitiatorAllTargets',
        'zoneNameFormat' => '{hostName}_{initiatorWwn}',
        'enableAliasing' => true,
        'initiatorNameFormat' => '{hostName}_{initiatorWwn}',
        'targetNameFormat' => '{storageSystemName}_{targetName}',
        'targetGroupNameFormat' => '{storageSystemName}_{targetGroupName}'
      }
    }
  }
end

describe type_class do
  let(:params) { %i[name data provider] }

  let(:special_ensurables) { %i[found set_refresh_state get_endpoints get_zoning_report] }

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to include(param)
    end
  end

  it 'should accept special ensurables' do
    special_ensurables.each do |value|
      expect do
        described_class.new(name: 'Test',
                            ensure: value,
                            data: {})
      end.to_not raise_error
    end
  end

  it 'should require a name' do
    expect do
      type_class.new({})
    end.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should require data to be a hash' do
    modified_config = managed_san_config
    modified_config[:data] = ''
    resource_type = type_class.to_s.split('::')
    expect do
      type_class.new(modified_config)
    end.to raise_error(Puppet::Error, 'Parameter data failed on' \
    " #{resource_type[2]}[#{modified_config[:name]}]: Inserted value for data is not valid")
  end
end
