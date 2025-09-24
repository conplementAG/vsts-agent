### Start the image

Now that you have created an image, you can run a container.

 Run the container. This installs the latest version of the agent, configures it, and runs the agent. It targets the `Default` pool of a specified Azure DevOps or Azure DevOps Server instance of your choice:

    ```shell
    docker run -e VSTS_ACCOUNT=<Azure DevOps instance> -e VSTS_TOKEN=<PAT token> -e VSTS_AGENT=mydockeragent conplementag/vsts-agent:3.0
    ```

Optionally, you can control the pool and agent work directory by using additional [environment variables](#environment-variables).


## Environment variables

| Environment variable | Description                                                  |
|----------------------|--------------------------------------------------------------|
| VSTS_ACCOUNT         | The URL of the Azure DevOps or Azure DevOps Server instance. |
| VSTS_TOKEN           | Personal Access Token (PAT) with **Agent Pools (read, manage)** scope, created by a user who has permission |
| VSTS_AGENT           | Agent name (default value: the container hostname).          |
| VSTS_POOL            | Agent pool name (default value: `Default`).                  |
| VSTS_WORK            | Work directory (default value: `_work`).                     |


Find all details here: https://github.com/MicrosoftDocs/azure-devops-docs/blob/master/docs/pipelines/agents/docker.md

## Base Image 
Ubuntu 22.04.

## Installed tools

- git             : 2.44.0
- openjdk         : 18
- dotnet          : 6.0, 8.0
- node            : 21.x
- docker          : 28.4.0
- docker-compose  : 2.39.4
- docker-buildx   : 0.28.0 (with BuildKit support)
- yarn 
- lerna
