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

# NOTE: As with all resources, the found ensurable accepts a data as an optional filter field.

image_streamer_deployment_plan{'deployment_plan_1':
    ensure => 'present',
    data   => {
      name           => 'Demo Deployment Plan',
      description    => 'Description of this Deployment Plan',
      hpProvided     => false,
      oeBuildPlanURI => 'Build Plan MK',
      goldenImageURI => 'GoldenImageMK'
    }
}

image_streamer_deployment_plan{'deployment_plan_2':
    ensure  => 'found',
    require => Image_streamer_deployment_plan['deployment_plan_1'],
    data    => {
      name => 'Demo Deployment Plan',
    }
}

image_streamer_deployment_plan{'deployment_plan_3':
    ensure  => 'present',
    require => Image_streamer_deployment_plan['deployment_plan_2'],
    data    => {
      name        => 'Demo Deployment Plan',
      new_name    => 'Demo Deployment Plan Renamed',
      description => 'New description'
    }
}

image_streamer_deployment_plan{'deployment_plan_4':
    ensure  => 'absent',
    require => Image_streamer_deployment_plan['deployment_plan_3'],
    data    => {
      name => 'Demo Deployment Plan Renamed'
    }
}
