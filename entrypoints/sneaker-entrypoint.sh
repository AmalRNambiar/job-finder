#!/bin/sh

set -e

bundle exec rake sneakers:run WORKERS=JobsWorker
