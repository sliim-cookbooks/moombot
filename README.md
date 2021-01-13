# moombot Cookbook

IRC Bot as a service managed with Chef! | [![Cookbook Version](https://img.shields.io/cookbook/v/moombot.svg)](https://community.opscode.com/cookbooks/moombot) [![Build Status](https://travis-ci.org/sliim-cookbooks/moombot.svg?branch=master)](https://travis-ci.org/sliim-cookbooks/moombot) 

## Requirements

#### Platforms
The following platforms and versions are tested and supported using Opscode's test-kitchen:
- `Debian 8`
- `Debian 9`
- `Debian 10`
- `Ubuntu 16.04`
- `Ubuntu 18.04`
- `Ubuntu 20.04`

## Usage

#### moombot::default

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[moombot]"
  ]
}
```

Testing
-------
See [TESTING.md](TESTING.md)

Contributing
------------
See [CONTRIBUTING.md](CONTRIBUTING.md)

## License and Authors

Authors: Sliim <sliim@mailoo.org>

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

