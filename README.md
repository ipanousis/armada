GCE with CoreOS:

1. Create coreos/cloud-config.yml with auth token from https://discovery.etcd.io/new
2. Modify and run ./boot script
3. gcloud compute ssh <instance name>
4. fleetctl list-machines

Example: ElasticSearch cluster on CoreOS
 - source: http://mattupstate.com/coreos/devops/2014/06/26/running-an-elasticsearch-cluster-on-coreos.html

GCE without CoreOS:

1. Setup GCE project - https://cloud.google.com/compute
2. gcloud auth login
3. Install gcloud compute
  # setup google cloud sdk
  curl https://sdk.cloud.google.com | bash
  # activate google cloud in current shell
  source ~/.bash_profile
  # login
  gcloud auth login --no-launch-browser
  # set defaults;
  gcloud config set project <project ID (not project name)>
  gcloud config set compute/region europe-west1
  gcloud config set compute/zone europe-west1-a
  gcloud config list # to verify the values are set

Flocker:

1. If testing flocker on using virtualbox

- install latest vagrant version from https://www.vagrantup.com/downloads

- vagrant up 
- sh virtualbox-populate-hosts.sh

- go into flocker/ and populate deployment.yml with the private IP of the VMs
( run etcd, docker-register and confd )

- flocker-deploy deployment.yml application.yml

- then, e.g., put elasticsearch service name (from application.yml) in one or more of the IPs in deployment.yml
- and do flocker-deploy deployment.yml application.yml

2. If using flocker with google cloud

Notes:

- the deployment.yml will control all services started on the flocker cluster even if they are not contained in the application.yml provided last

++++++++

+ service for deployment.yml
+ web ui for deployment.yml


