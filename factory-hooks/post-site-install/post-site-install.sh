#!/bin/bash
#
# Factory Hook: post-site-install
#
# This is necessary so that drush drupal:install tasks are invoked automatically
# when a site is created on ACSF.
#
# Usage: post-site-install.sh sitegroup env db-role domain

# Exit immediately on error and enable verbose log output.
set -ev

# Map the script inputs to convenient names:
# Acquia Hosting sitegroup (application) and environment.
sitegroup="$1"
env="$2"
# Database role. This is a truly unique identifier for an ACSF site and is e.g.
# part of the public files path.
db_role="$3"
# Internal (Acquia managed) domain name of the website. (No public domain name
# is assigned yet, immediately after installation.) The first part is a name
# that is unique per installed site. A small but significant difference with
# $db_role: if a site gets deleted and reinstalled with the same name, it gets
# a different $db_role.
internal_domain="$4"

# Drush executable:
drush="/mnt/www/html/$sitegroup.$env/vendor/bin/drush"

# Execute the updates.
${drush} drupal:update --uri=$internal_domain --verbose --no-interaction
result=$?

set +v

# Exit with the status of the drush commmand. If the exit status is non-zero,
# Site Factory will send a notification of a partiolly failed install and will
# stop executing any further post-site-install hook scripts that would be in
# this directory (and get executed in alphabetical order).
exit $result
