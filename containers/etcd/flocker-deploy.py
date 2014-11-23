#!/usr/bin/env python
#
# This script will take a fig.yml file containing 1 service
# and the number of instances desired for this service.
#
# It will then use an existing application.yml and deployment.yml
# (which essentially store the current "state" of the flocker cluster)
# and append the given service to the application.yml as well as
# adjust the deployment.yml with the desired number of instances for
# this service.
#

import os
import yaml
import shutil
import argparse

APPLICATION_YML = os.getenv('FLOCKER_APPLICATION_YML')
DEPLOYMENT_YML  = os.getenv('FLOCKER_DEPLOYMENT_YML')

parser = argparse.ArgumentParser()
parser.add_argument(dest = 'serviceyaml', help = 'Service yaml file, fig-formatted')
parser.add_argument(dest = 'instances', type = int, help = 'Number of new instances for this service')
args = parser.parse_args()

service_yaml = args.serviceyaml
num_instances = args.instances

service_definition = yaml.load(open(service_yaml, 'r'))
service_name = service_definition.keys()[0]
application_yaml = open(APPLICATION_YML + '-to-be', 'w')
application_yaml.write(yaml.dump(service_definition, Dumper=yaml.CDumper))
application_yaml.close()

deployment_yaml = yaml.load(open(DEPLOYMENT_YML, 'r'))

deployment_nodes = deployment_yaml['nodes']

lightest_node = min(deployment_nodes.keys(), key=(lambda x:len(deployment_nodes[x])))

deployment_nodes[lightest_node].append(service_name)

num_services = sum([len(services) for services in deployment_nodes.values()])

deployment_yaml_to_be_name = DEPLOYMENT_YML + '-to-be'
deployment_yaml_to_be = open(deployment_yaml_to_be_name, 'w')
deployment_yaml_string = yaml.dump(deployment_yaml, default_style='"', Dumper=yaml.CDumper)
deployment_yaml_to_be.write(deployment_yaml_string)
deployment_yaml_to_be.close()

#shutil.copyfile(deployment)



