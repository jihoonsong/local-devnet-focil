# Local Devnet FOCIL

This repository provides bash scripts for building Docker images of Prysm and Geth, along with a Kurtosis configuration file for running a local devnet.

## Prerequisite

Before getting started, ensure that you have Docker and Kurtosis installed:

1. [Install Docker and start the Docker Daemon][docker-installation]
2. [Install the Kurtosis CLI, or upgrade it to the latest version][kurtosis-cli-installation]

## Building Docker Images

Docker image building scripts are located in the `geth` and `prysm` directories. Place these scripts at the root of each respective repository and execute them to build the Docker images.

You can also use Docker images from Docker Hub, if you're interested in running a local devnet only.

## Running a Local Devnet

1. **Run a Local Devnet with Kurtosis**

Once you have Docker images prepared, you can launch a local devnet using them with Kurtosis:

```bash
cd kurtosis
make run
```

If you prefer to run a local devnet using the Docker images from Docker Hub:

```bash
cd kurtosis
make run-registry
```

2. **Access Dora the Explorer**

Dora the Explorer is accessible at [localhost:65500][dora-the-explorer]

3. **Stop the Local Devnet**

To stop the devnet, run:

```bash
make stop
```

You can also place the `kurtosis` folder within the Prysm or Geth repository that you are actively developing, for your convenience.

<!------------------------ Only links below here -------------------------------->

[docker-installation]: https://docs.docker.com/get-docker
[kurtosis-cli-installation]: https://docs.kurtosis.com/install
[dora-the-explorer]: http://localhost:65500
