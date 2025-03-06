#!/bin/sh
PROJECT_DIRECTORY="/app/${DIRECTORY_NAME:-project}"
SUBFOLDER=${SUBFOLDER_PATH:-""}  # Fetch the sub-folder path from an environment variable

git config --global pull.rebase false

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
  rsync -vazC $PROJECT_DIRECTORY/$SUBFOLDER ${DESTINATION_PATH:-/app/sync}
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
    rsync -vazC $PROJECT_DIRECTORY/ ${DESTINATION_PATH:-/app/sync}
  else
    rsync -vazC $PROJECT_DIRECTORY/$SUBFOLDER ${DESTINATION_PATH:-/app/sync}
  fi
done
