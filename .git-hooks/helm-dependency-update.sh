#!/bin/bash

ct list-changed | xargs -d '\n' -I {} helm dependency update {}
