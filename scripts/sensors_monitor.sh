#!/bin/bash

watch -n 1 'sensors | egrep "Tdie|Tctl|fan|in0"'
