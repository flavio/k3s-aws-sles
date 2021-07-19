Quick way to create a k3s cluster on AWS using terraform.

# Architecture

This section describes the architecture of the final deployment.

Some of these details can be tuned via terraform variables. See the `variables.tf`
and the `terraform.tfvars.example` files.

## Network

All the compute instances a placed inside of a dedicated VPC.

The control plane nodes have public IPs. They expose SSH and the Kubernetes API port.

Worker nodes are not exposed outside of the VPC.

A ELB instance is created to expose the Kubernetes API service. This is the recommend way to interact with the cluster.

## Compute nodes

All the nodes are going to be deployed using SLES 15. By default the nodes will
use the amd64 architecture, but it's possible to deploy them using the ARM64 one.

**Warning:** ensure the `server_type` and `agent_type` flavors are compatible
with the architecture you have chosen.

It's possible to create either reserved instances, or spot ones.

# k3s setup

Once the terraform run is done, the deployment of the cluster can be done using
the [k3sup](https://github.com/alexellis/k3sup) cli tool.

Deployment of the 1st control plane node, this can be done from your local machine:

```console
$ k3sup install \
  --tls-san fcastelli-k3s-elb-561437306.eu-west-1.elb.amazonaws.com \ # replace with the FQDN of the ELB instance
  --k3s-extra-args "--node-name ip-10-1-1-78.eu-west-1.compute.internal" \ # replace with the internal FQDN name of the node
  --ip 63.33.196.205 \ # replace with the public IP of the node
  --cluster \ # this uses the embedded etcd setup
  --sudo --user ec2-user
```

k3sup will download the kubeconfig file. Edit it and replace the public IP address
of the node with the FQDN of the load balancer.

Then join the other control plane nodes in this way:

```console
$ k3sup join \
  --k3s-extra-args "--node-name ip-10-1-1-158.eu-west-1.compute.internal" \ # replace with the internal FQDN name of the node
  --ip 3.250.216.193 \ # replace with the public IP of the node
  --server \ # this joins the node as a server
  --server-user ec2-user \
  --server-ip 63.33.196.205 \ # replace with the public IP address of the 1st server node
  --sudo --user ec2-user
```

Repeat this command to join each server node.

Now you can join the agent nodes.

Before proceeding, you need to:
  * ssh into the 1st server node, ensure you forward your `ssh-agent` session.
    This can be done with the following command: `ssh -A ec2-user@<ip of the server node>
  * Install k3sup on the node

Then proceed with following command:
```console
# k3sup join \
  --host ip-10-1-1-254.eu-west-1.compute.internal \ # replace with the internal FQDN of the agent node
  --sudo --user ec2-user \
  --server-user ec2-user \
  --server-ip 63.33.196.205 \ # replace with the public IP address of the 1st server node
```

Now you're ready to go:

```console
$ kubectl get nodes
NAME                                       STATUS   ROLES         AGE     VERSION
ip-10-1-1-122.eu-west-1.compute.internal   Ready    etcd,master   12m     v1.19.12+k3s1
ip-10-1-1-158.eu-west-1.compute.internal   Ready    etcd,master   14m     v1.19.12+k3s1
ip-10-1-1-254                              Ready    <none>        3m57s   v1.19.12+k3s1
ip-10-1-1-78.eu-west-1.compute.internal    Ready    etcd,master   21m     v1.19.12+k3s1
```
