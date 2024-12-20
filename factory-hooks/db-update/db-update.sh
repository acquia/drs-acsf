#!/bin/bash
#
# Factory Hook: db-update
#
# The existence of one or more executable files in the
# /factory-hooks/db-update directory will prompt them to be run *instead of* the
# regular database update (drush updatedb) command. So that update command will
# normally be part of the commands executed below.
#
# Usage: db-update.sh sitegroup env db-role domain custom-arg

# Exit immediately on error and enable verbose log output.
set -ev

# Map the script inputs to convenient names:
# Acquia Hosting sitegroup (application) and environment.
sitegroup="$1"
env="$2"
# Database role. This is a truly unique identifier for an ACSF site and is e.g.
# part of the public files path.
db_role="$3"
# The public domain name of the website. If the site uses a path based domain,
# the path is appended (without trailing slash), e.g. "domain.com/subpath".
domain="$4"

# Drush executable:
drush="/mnt/www/html/$sitegroup.$env/vendor/bin/drush"

echo "Running DRS deploy tasks on $domain domain in $env environment on the $sitegroup subscription."

# Run drush drupal:update tasks. The trailing slash behind the domain works
# around a bug in Drush < 9.6 for path based domains: "domain.com/subpath/" is
# considered a valid URI but "domain.com/subpath" is not.
${drush} drupal:update --uri=$domain/ --verbose --no-interaction

set +v
