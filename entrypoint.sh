#!/bin/sh

echo "Starting the sync process"

chmod 600 /root/.ssh/id_rsa

PROJECT_DIRECTORY="${DIRECTORY_NAME:-/app/repo}"
DESTINATION="${DESTINATION_PATH:-/app/sync}"
SUBFOLDER=${SUBFOLDER_PATH:-""}  # Fetch the sub-folder path from an environment variable

# git config --global pull.rebase false

if [ ! -d "$PROJECT_DIRECTORY" ]; then
  mkdir -p "$PROJECT_DIRECTORY"
fi

if [ ! -d "${DESTINATION}" ]; then
  mkdir -p "${DESTINATION}"
fi

if [ ! -d "$PROJECT_DIRECTORY/.git" ]; then
  echo "Cloning the repository: $GIT_REPO_URL"
  # extract 
  BASE_URL=$(echo "$GIT_REPO_URL" | sed 's|https://||')  
  GIT_AUTH_REPO_URL="https://${GIT_USER}:${GIT_PASSWORD}@${BASE_URL}"

  mkdir -p $PROJECT_DIRECTORY
  git init $PROJECT_DIRECTORY
  cd $PROJECT_DIRECTORY
  git remote add origin $GIT_AUTH_REPO_URL
  git pull origin ${GIT_BRANCH:-main}
  rsync -vaz $PROJECT_DIRECTORY/$SUBFOLDER ${DESTINATION}
fi

if [[ "$PWD" != "$PROJECT_DIRECTORY" ]]
then
    cd "$PROJECT_DIRECTORY"
fi

while true; do
  echo "Syncing the repository every $INTERVAL seconds"
  git -C $PROJECT_DIRECTORY pull origin ${GIT_BRANCH:-main}
  git clean -fd
  sleep ${INTERVAL:-10}
  if [ -z "$SUBFOLDER" ]; then
    rsync $RSYNC_ARGS "$PROJECT_DIRECTORY/" "${DESTINATION}"
  else
    rsync $RSYNC_ARGS "$PROJECT_DIRECTORY/$SUBFOLDER" "${DESTINATION}"
  fi
done
