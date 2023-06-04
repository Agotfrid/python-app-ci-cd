# Python App Deployment Guide

This guide will help you set up and run a Python app locally, and explain how continuous delivery for staging or production is achieved with the help of ArgoCD.

## Prerequisites

Before you start, make sure the following tools are installed on your MacOS:

- Docker Desktop with Kubernetes: Download and install from [Docker Official Website](https://www.docker.com/products/docker-desktop).
- Kind: Install using Homebrew with `brew install kind`.
- Kustomize: Install using Homebrew with `brew install kustomize`.

## Local Development

Follow these steps to run the app locally:

1. Create a new cluster using kind with `kind create cluster --name local-app`.
2. Switch to the newly created cluster with `kubectl config use-context kind-local-app`.
3. Create a new namespace for the app using `kubectl create namespace python-app-develop`.
4. Clone the Kustomize repository using `git clone https://github.com/Agotfrid/kustomize-example`.
5. Navigate to the base of `kustomize-example` and apply the manifests to the new namespace using `kubectl apply -k overlays/develop -n python-app-develop`. This command will set up all the required Kubernetes resources including the app, a small MySQL server, required services, secret, ConfigMap, and PVC and PV for database usage.
6. Forward the port of the app service using `kubectl port-forward -n python-app-develop svc/python-app-service 5000:80` so that you can use the API on `localhost:5000`.
7. The API should now be usable!

## Continuous Delivery

This section explains how continuous delivery is set up for this project:

1. Once a GitHub Actions task successfully completes the build, tag, and push the Docker image to `agotfrid/python-app` (or any other artifact registry etc.), the next task updates the `kustomization.yaml` file in the `overlays` directory of the Kustomize repo with the new image version for the Python app. The tag used can be either `latest` or the commit hash of that particular release.
2. In a staging or production environment, we would have ArgoCD installed in the `argocd` namespace. This namespace includes an argo project and application that monitors the [Kustomize repository](https://github.com/Agotfrid/kustomize-example) for any changes. Onc a change is detected (such as an updated image tag), ArgoCD syncs these changes with the cluster, deploying the updated application.

