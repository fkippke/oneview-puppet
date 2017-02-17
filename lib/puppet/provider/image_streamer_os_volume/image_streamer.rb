################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

require_relative '../image_streamer_resource'

Puppet::Type.type(:Image_streamer_os_volume).provide :image_streamer, parent: Puppet::ImageStreamerResource do
  desc 'Provider for Image Streamer OS Volumes using the Image Streamer API'

  mk_resource_methods

  def exists?
    super([nil, :found, :get_details_archive])
  end

  def create
    raise 'This ensurable is not supported for this resource.'
  end

  def destroy
    raise 'This ensurable is not supported for this resource.'
  end

  def get_details_archive
    os_volume = get_single_resource_instance
    pretty os_volume.get_details_archive
    true
  end

  def resource_name
    'OSVolume'
  end

  def self.resource_name
    'OSVolume'
  end
end
