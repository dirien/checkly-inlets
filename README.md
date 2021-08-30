# How to use Checkly with Inlets tunnel

In this tutorial, I want to show you how to use inlets tunnel with Checkly.

The idea behind this, is to show how to we can use inlets to create tunnel from our on-premise to use a pure SaaS
solution like Checkly to monitor the on-prem application

## Checkly

[Checkly](https://www.checklyhq.com/) is the API & E2E monitoring platform for the modern stack: programmable, flexible
and loving JavaScript.

You can create a [free account](https://app.checklyhq.com/signup) and start creating cool API and Browser Checks. You
can run your checks from over 20 locations worldwide. It has great CI / CD integrations and much more under the hood.
You should go and check it out.

## Inlets

For anyone not familiar with inlets. It's a project from [Alex Ellis](https://twitter.com/alexellisuk), a CNCF
Ambassador and the Founder of OpenFaaS.

> Cloud Native Tunnel You can use inlets to connect HTTP and TCP services between networks securely. Through an encrypted websocket, inlets can penetrate firewalls, NAT, captive portals, and other restrictive networks lowering the barrier to entry.
>
>VPNs traditionally require up-front configuration like subnet assignment and ports to be opened in firewalls. A tunnel with inlets can provide an easy-to-use, low-maintenance alternative to VPNs and other site-to-site networking solutions.

### Let's roll

We're going to use `Task` here to quickly spin up the necessary tools. `Task` is a task runner / build tool that aims to
be simpler and easier to use than, for example, GNU Make.

Since it’s written in Go, Task is just a single binary and has no other dependencies, which means you don’t need to mess
with any complicated install setups just to use a build tool.

#### Install Taskfile

Check the [installation](https://taskfile.dev/#/installation?id=installation) for more installation options. Here I use
brew.

    brew install go-task/tap/go-task

#### Mock the on-prem service.

The task `k8s-init-sock-shop` installs the [Weaveworks Sock Shop](https://microservices-demo.github.io/) to mock an
application running on-prem. I install it on a k3s via `Rancher Desktop`

```yaml
  k8s-init-sock-shop:
    desc: install the sock shop
    cmds:
      - kubectl get nodes
      - kubectl apply -f https://raw.githubusercontent.com/microservices-demo/microservices-demo/master/deploy/kubernetes/complete-demo.yaml
      - kubectl apply -f socks-ingress.yaml
```

#### Deploy everything

Just type:

```shell
task
```

To deploy the default task, which is a composition of:

```shell
  default:
    cmds:
      - task: init-checkly
      - task: k8s-init-sock-shop
      - task: inlets-operator
      - task: checkly-terraform
```

We deploy inlets via the inlets-operator on our kubernetes cluster. As an exit-node provider, we are going to
use [scaleway](https://www.scaleway.com/en/) for this.

#### Checkly Terraform

To define our Checkly checks, we are using the [checkly](https://registry.terraform.io/providers/checkly/checkly/latest)
terraform provider. So change the `terraform.tfvars.changme` to `terraform.tfvars` in the `checkly-tf` folder and put
the checkly API key into it.

Or use the task:

```shell
task tfvars
```

Check the great [docs](https://www.checklyhq.com/docs) for more details on Checkly.