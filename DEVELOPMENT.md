# Control Plane

## Development Setup

To set up the development environment, you need the following pre-requisites:

- [Docker](https://www.docker.com/): To run the service and its dependencies.
- [Tilt](https://docs.tilt.dev/install.html): To run the development environment.
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries): To run the Kubernetes cluster.
- [Helm](https://helm.sh/): To install the application.
    - `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash`
- [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl): To interact with the Kubernetes cluster (optional, but useful for debugging).

### Tilt (Running the application locally)

Create your local development cluster as follows:

```bash
kind create cluster --name control-plane
```

#### Posthog Reverse Proxy

To run the application locally, we will use `kind` and `tilt` to run a local Kubernetes cluster and deploy the application to it.

Copy the `.env.example` file to `.env` in `deploy/tilt/posthog-reverse-proxy` and set the `POSTHOG_PROJECT_API_KEY` environment variable.

To deploy the application, run `tilt up`.
