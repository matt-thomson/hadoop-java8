#!/bin/bash
rm -r cookbooks
bundle exec berks vendor cookbooks
packer build packer.json
