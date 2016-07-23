## selenium [![Build Status](https://travis-ci.org/arknoll/ansible-role-selenium.svg?branch=master)](https://travis-ci.org/arknoll/ansible-role-selenium)

Set up selenium and Firefox for running selenium tests.

#### Requirements

* `java`

#### Variables

* `selenium_install_dir`: [default: `/opt`] Install directory
* `selenium_version`: [default: `2.44.0`] Install version

## Dependencies

None

#### Example

```yaml
---
- hosts: all
  roles:
  - selenium
```

#### Start/Stop/Restart Selenium

```
$ service selenium start
$ service selenium stop
$ service selenium restart
```

#### License and Author

Author:: Alex Knoll (arknoll@gmail.com)

Copyright:: 2015, Alex Knoll

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

#### Contributing

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
