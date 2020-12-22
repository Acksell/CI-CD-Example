# CI/CD Example
![](https://github.com/Acksell/CI-CD-Example/workflows/ci-cd/badge.svg)
## Introduction
This repository contains a hello world python server along with a Github Actions pipeline/workflow that tests the application, builds a docker image, and publishes the image to Github Container Registry. There is also a [startup script](https://github.com/Acksell/CI-CD-Example/blob/master/start_watchtower.sh) for [watchtower](https://containrrr.dev/watchtower/), a tool for detecting remote changes to currently running docker containers and promptly restarting any container with the latest image, used for deployment.


## Configuration
### Github Container Registry
Because Github Container Registry is currently in beta one has to enable the feature manually, either for an organisation or individual account. For instructions on how to do so, see ["Enabling improved container support."](https://docs.github.com/en/free-pro-team@latest/packages/guides/enabling-improved-container-support).


From [https://docs.github.com/en/free-pro-team@latest/packages/guides/about-github-container-registry](https://docs.github.com/en/free-pro-team@latest/packages/guides/about-github-container-registry):

>Note: GitHub Container Registry is currently in public beta and subject to change. During the beta, storage and bandwidth are free. To use GitHub Container Registry, you must enable the feature for your account. For more information, see ["Enabling improved container support."](https://docs.github.com/en/free-pro-team@latest/packages/guides/enabling-improved-container-support)

In order for this repository's workflow to work you also need to [set a secret](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets) in your project repository for the github actions workflow to work: `GHCR_PAT`, a personalized access token. This currently the only way to access the Github Container Registry via Github Actions. [Read more about how to issue one and what privileges to give it](https://docs.github.com/en/free-pro-team@latest/packages/guides/pushing-and-pulling-docker-images).

If the repository resides under an organization you might want to create a new user solely for the purpose of issuing this PAT. You also have to change the workflow to use that username since `${{ github.repository_owner }}` will otherwise refer to the organization in the following stage of the deploy job:

```
      - 
        name: Login to Github Registry
        uses: docker/login-action@v1
        with:
          registry: ghcr.io
          # Change this if under an organization
          username: ${{ github.repository_owner }}
          # Github Container Registry, Personal Access Token.
          # Currently in the GHCR beta, a PAT is the only way to access GHCR through actions. 
          password: ${{ secrets.GHCR_PAT }}
```

## Watchtower
### Setup
Watchtower also needs to be able to access Github Container Registry. To set this up simply run the following with your PAT and corresponding username instead:

```
export GHCR_PAT=YOUR_PAT_GOES_HERE
echo $GHCR_PAT | docker login ghcr.io -u USERNAME --password-stdin
```

This will generate a `~/.docker/config.json` file that is later mounted as a volume to the watchtower container when ran. 

### Running

Simply run the provided `./start_watchtower.sh` script! There is some more documentation about different arguments and watchtower in the file itself.

>Note: One might want to create a symlink to the config file instead of mounting the config file directly in order for changes to propagate properly to the watchtower container. Read more: https://containrrr.dev/watchtower/usage-overview/. 
