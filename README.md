Based on https://github.com/data-burst/git-sync but clonning using http

### Configuration

| Variable | Description |
| --- | --- | 
| `GIT_REPO_URL` (required) | URL of the git repo |
| `GIT_BRANCH` | Git branch branch (default: `main`) |
| `GIT_USER` (required) | Username |
| `GIT_PASSWORD` (required) | Password or Personal Access Token |
| `SUBFOLDER_PATH` | The sub-folder within the repository to sync. If left empty, the entire repository will be copied.| 
| `DIRECTORY_NAME` | The directory name where the repository will be cloned. (default `/app/repo`) |
| `DESTINATION_PATH` | The path to sync the repository to (default `/app/sync`) |
| `SYNC_INTERVAL` | The time interval (in seconds) for syncing the repository. (default `10`)|
| `RSYNC_ARGS` | rsync command arguments (default `-vaz --exclude='.git' --delete`)|

More references https://github.com/data-burst/airflow-git-sync