#!/bin/bash
if [ -d "$DIRECTORY" ]; then
	rm -r cookbooks
fi

bundle install
bundle exec berks vendor cookbooks
packer build packer.json
