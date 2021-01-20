#!/usr/bin/env bash

set -eo pipefail

[[ ! $# -eq 1 ]] && echo "Usage: $0 backup_number" && exit 1;
[[ -z "${BACKUP_DIR}" ]] && echo "Required 'BACKUP_DIR' env not set" && exit 1;
[[ -z "${JENKINS_HOME}" ]] && echo "Required 'JENKINS_HOME' env not set" && exit 1;
BACKUP_TMP_DIR=$(mktemp -d)

backup_number=$1
#backup_number=999

echo "Running backup"

# config.xml in a job directory is a config file that shouldnt be backed up
# config.xml in child directores is state that should. For example-
# branches/myorg/branches/myrepo/branches/master/config.xml should be retained while
# branches/myorg/config.xml should not
# tar -C ${JENKINS_HOME} -czf "${BACKUP_TMP_DIR}/${backup_number}.tar.gz" --exclude jobs/*/workspace* --no-wildcards-match-slash --anchored  -c jobs nodes secrets userContent users init.groovy.d config.xml nodeMonitors.xml secret.key secret.key.not-so-secret && \
tar -C ${JENKINS_HOME} -czf "${BACKUP_TMP_DIR}/${backup_number}.tar.gz" --exclude jobs/*/workspace* --no-wildcards-match-slash --anchored --exclude ./workspace --exclude ./plugins --exclude ./war  -c . && \
mv ${BACKUP_TMP_DIR}/${backup_number}.tar.gz ${BACKUP_DIR}/${backup_number}.tar.gz

[[ ! -s ${BACKUP_DIR}/${backup_number}.tar.gz ]] && echo "backup file '${BACKUP_DIR}/${backup_number}.tar.gz' is empty" && exit 1;

echo Done
exit 0
