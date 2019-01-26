# k8s-dind

Note: I ran this on Amazon EC2 - 4.14.88-88.73.amzn2.x86_64

- Make sure 'docker info' is working with ec2-user instead of root.  
- Use https://github.com/kubernetes-sigs/kubeadm-dind-cluster setup instructions to run a k8s cluster with docker-in-docker  
- Run `export APISERVER_PORT=8099` before running [the port forwarding script](https://raw.githubusercontent.com/bbideep/k8s-dind/master/setup-port-forwarding.sh), or the downloaded script from the above step.  
