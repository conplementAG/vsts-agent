### Start the image

Now that you have created an image, you can run a container.

 Run the container. This installs the latest version of the agent, configures it, and runs the agent. It targets the `Default` pool of a specified Azure DevOps or Azure DevOps Server instance of your choice:

    ```shell
    docker run -e AZP_URL=<Azure DevOps instance> -e AZP_TOKEN=<PAT token> -e AZP_AGENT_NAME=mydockeragent cgot/linux-dockeragent:latest
    ```

Optionally, you can control the pool and agent work directory by using additional [environment variables](#environment-variables).


## Environment variables

| Environment variable | Description                                                 |
|----------------------|-------------------------------------------------------------|
| AZP_URL              | The URL of the Azure DevOps or Azure DevOps Server instance. |
| AZP_TOKEN            | Personal Access Token (PAT) with **Agent Pools (read, manage)** scope, created by a user who has permission |
| AZP_AGENT_NAME       | Agent name (default value: the container hostname).          |
| AZP_POOL             | Agent pool name (default value: `Default`).                  |
| AZP_WORK             | Work directory (default value: `_work`).                     |


Find all details here: https://github.com/MicrosoftDocs/azure-devops-docs/blob/master/docs/pipelines/agents/docker.md