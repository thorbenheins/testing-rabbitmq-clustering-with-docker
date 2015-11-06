Testing RabbitMQ Clustering and High Availability with Docker Compose
================================================

This repository is built to host a local RabbitMQ cluster inside Docker containers managed and linked together using Compose. Once the cluster is running there are management scripts that allow for simulating outages, ssh-ing into the containers, testing configurations, and restoring cluster services for testing RabbitMQ High Availability.

Additionally, this was built to help demonstrate how to build a base Docker Container and then extend this base into a useable cluster-able version. By going in sequence from steps 1, 2, 3, 4 someone with little Docker experience can start playing with multiple containers hosting a useable RabbitMQ cluster running locally. The code and scripts have only been tested on Fedora.

This cluster supports clients using:
 - AMQP on Port 5672 
 - MQTT Non-SSL on Port 1883 
 - MQTT SSL on Port 8883 (Port is exposed, but no SSL cert is included)

Once the steps are completed here is what your local environment will look like:
![Environment Overview](http://levvel.io/wp-content/uploads/2015/11/RabbitMQ-Clustering-on-Docker-for-use-with-AMQP-and-MQTT.png)

### Overview
-----------

Here is the repository layout and a brief description of the included files.

```
.
├── 1_build_cluster_base_image.sh - Step 1: Build a CentOS base image on your local machine
├── 2_build_cluster_node_image.sh - Step 2: Build the RabbitMQ cluster image by extending the CentOS base image
├── 3_start.sh - Step 3: Start the cluster using docker-compose
├── 4_stop.sh - Step 4: Stop the cluster using docker-compose
├── baseimage                       
│   └── Dockerfile - Base Image Manifest Dockerfile running a minimal CentOS install
├── bindings.sh - Show Cluster Bindings
├── cluster                         
│   └── docker-compose.yml - Docker Compose manifest for organizing the cluster, Services, Resources, and Links
├── common.sh - Common definitions for images, containers and metadata
├── container_ssh.sh - Generic Docker ssh wrapper with argument <cluster_rabbit1_1|cluster_rabbit2_1|cluster_rabbit3_1>
├── CONTRIBUTING - General Contributing Steps
├── _destroy_all_local_containers
│   └── destroy_all_containers.sh - If something breaks during a build you can destroy all Docker assets to an original state
├── end_node_1.sh - Use Docker Compose to take down the RabbitMQ cluster Node 1
├── end_node_2.sh - Use Docker Compose to take down the RabbitMQ cluster Node 2
├── end_node_3.sh - Use Docker Compose to take down the RabbitMQ cluster Node 3
├── exchanges.sh - Show Cluster Exchanges
├── force_stop.sh - Non-graceful force stop using Docker without Compose - NOT recommended
├── list_running_containers.sh - List the Docker containers on the local machine
├── LICENSE - Apache 2.0 License
├── msg_queues.sh - Show Cluster Queue Message Details
├── queues.sh - Show Cluster General Queues
├── README.md - Readme File
├── remove_container.sh - (Optional) Utility cleanup image wrapper for restoring free disk space
├── rst - RabbitMQ cluster Status script to quickly inspect the cluster's health
├── server
│   ├── debugnodes.sh - When debugging Docker startup, this type of script can start the container for ssh logins (Installed in the container)
│   ├── Dockerfile - RabbitMQ cluster Node Manifest Dockerfile extending the Base container's image
│   ├── erlang.cookie - RabbitMQ requires a shared cookie file on each cluster node (Installed in the container)
│   ├── localcluster.config - Not Used but included as a sample configuration from a non-Docker cluster
│   ├── rabbitmq.config - Docker RabbitMQ Node cluster configuration file (Installed in the container)
│   ├── rabbitmq-env.conf - Allow for specific environment variables to be passed through at the Docker container (Installed in the container)
│   ├── rl - Tail the /tmp/rabbitnode.log for errors (Installed in the container)
│   ├── rst - Inspect the RabbitMQ Node's cluster status. Useful for split brain and quorum issues (Installed in the container) 
│   ├── simulator_tools - Tooling for the Clustering and High Availability Simulator
│   │   ├── join_cluster.sh - Join the cluster tool for the Simulator (Installed in the container)
│   │   ├── leave_cluster.sh - Join the cluster tool for the Simulator (Installed in the container)
│   │   ├── reset_first_time_running.sh - Reset tool for debugging container installation issues (Installed in the container)
│   │   ├── start_node.sh - Start node tool for the Simulator (Installed in the container)
│   │   └── stop_node.sh - Stop the node tool for the Simulator (Installed in the container)
│   ├── startclusternode.sh - Start script for running a non-clustered and clustered RabbitMQ Servers in a Docker container (Installed in the container)
│   └── tl - Shortcut for tailing the RabbitMQ logs in /var/log/rabbit/*.log (Installed in the container)
├── ssh_node_1.sh - SSH into the RabbitMQ Node 1 container using this Docker wrapper
├── ssh_node_2.sh - SSH into the RabbitMQ Node 2 container using this Docker wrapper
├── ssh_node_3.sh - SSH into the RabbitMQ Node 3 container using this Docker wrapper
├── start_node_1.sh - Use Docker Compose to start the RabbitMQ cluster Node 1 Container
├── start_node_2.sh - Use Docker Compose to start the RabbitMQ cluster Node 2 Container
├── start_node_3.sh - Use Docker Compose to start the RabbitMQ cluster Node 3 Container
└── test_simulations - Docker RabbitMQ Cluster Regression Tests with the Message Simulator
    ├── burst
    │   └── burst_1_send_100000_messages.json
    ├── ha
    │   ├── ha_1_start_sending_and_crash_a_node.json
    │   ├── ha_2_start_sending_and_stop_then_start_a_node.json
    │   └── ha_3_network_latency_event_during_messaging.json
    ├── load
    │   ├── load_1_send_100000_messages.json
    │   ├── load_2_start_sending_and_consuming_messages.json
    │   └── load_3_start_sending_and_leave_consumers_running.json
    ├── README.MD
    ├── setup_validation
    │   ├── __BE_CAREFUL_RESET_CLUSTER.json
    │   ├── docker_cluster_hello_world.json
    │   ├── validate_1_docker_remote_access.json
    │   ├── validate_2_consumer_works.json
    │   └── validate_3_send_100_messages.json
    └── stress
        ├── stress_1_a_send_10000000_msgs_over_fanout_to_many_queues.json
        └── stress_1_b_send_10000000_msgs_over_fanout_to_many_queues.json
```

### Features

The technology in this repository is RabbitMQ brokers running in CentOS Containers managed by Docker and linked together as a cluster using Docker Compose.

The repository provides a simple set of steps to see, manage, examine, break, and restore the RabbitMQ cluster for demonstration purposes.

### Learn More

Here are some underlying systems and components:

| Technology                 | Learn More Link                                     |
| -------------------------- | --------------------------------------------------- |
| Docker                     | https://docs.docker.com/userguide/                  | 
| Docker Compose             | https://docs.docker.com/compose/                    |
| RabbitMQ                   | https://www.rabbitmq.com/                           |
| RabbitMQ Getting Started   | https://www.rabbitmq.com/getstarted.html            |
| RabbitMQ High Availability | https://www.rabbitmq.com/reliability.html           |
| RabbitMQ Debugging         | https://www.rabbitmq.com/man/rabbitmqctl.1.man.html |

#### Technical Documentation

This is a repository used for hosting a RabbitMQ cluster running in Docker Containers and managed by Compose.

Getting Started
------------------

### Setup and Installation 

Install the base RPMs (Assumes Fedora/CentOS)

```
$ sudo yum install -y erlang
$ sudo yum install -y http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server-3.5.6-1.noarch.rpm
$ /usr/sbin/rabbitmq-plugins enable rabbitmq_mqtt rabbitmq_stomp rabbitmq_management  rabbitmq_management_agent rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management sockjs

$ sudo yum install python-setuptools git-core
$ sudo pip install --upgrade pip
$ sudo pip install pika==0.10.0
```

Optional - These are not required, but I usually have the following RPMs and Python pips installed:

```
$ sudo yum -y install pwgen wget logrotate mlocate gettext gettext-devel tcl tcl-devel expat-devel boost boost-devel make autoconf gcc openssl openssl-devel libxml2-devel perl perl-devel curl-devel python-devel libxslt libxslt-devel pcre-devel gcc-c++ sqlite-devel procps which hostname sudo net-tools vim
$ sudo pip install --upgrade pip
$ sudo pip install unittest2 selenium pylint panda feedparser beautifulsoup4 requests six mimeparse constants flup sqlalchemy redis lxml pysqlite simplejson importlib boto
```

Install Docker (https://docs.docker.com/installation/fedora/)

```
$ sudo yum install docker-engine
```

Start Docker

```
$ sudo service docker start
```

Optional - Make Docker start on a reboot

```
$ sudo chkconfig docker on
```

Install Docker Compose

```
$ sudo pip install -U docker-compose
```

Confirm Docker is working

```
$ docker images -a
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
$
```

```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
$
```

Install RabbitMQ Admin Tool

```
wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_5_6/bin/rabbitmqadmin -O /tmp/rabbitmqadmin
sudo chmod 777 /tmp/rabbitmqadmin
sudo mv /tmp/rabbitmqadmin /usr/bin/rabbitmqadmin
```

Confirm the RabbitMQ Admin tool is ready

```
$ which rabbitmqadmin 
/usr/bin/rabbitmqadmin
$
```

#### Concepts

There are multiple components getting used going forward. We will build a base CentOS Docker Container image, then extend it to host a RabbitMQ cluster, and then examine RabbitMQ's support for High Availability.

#### Starting the RabbitMQ Cluster using Docker Compose 

For demonstration purposes the repository file structure was kept flat to allow simple execution without having to change directories.

1. Build the Base Image:

    ```
    $ ./1_build_cluster_base_image.sh 
    Building new Docker Base image(levvel/rabbitclusterbase)
    Sending build context to Docker daemon  2.56 kB
    Step 0 : FROM centos
    Trying to pull repository docker.io/library/centos ... latest: Pulling from library/centos
    47d44cb6f252: Pull complete 
    168a69b62202: Pull complete 

    ... (skipping output to shorten README)

    Step 6 : RUN touch /tmp/firsttimerunning
     ---> Running in c1ea0ef92dfe
     ---> bd61935b3201
    Removing intermediate container c1ea0ef92dfe
    Successfully built bd61935b3201
    $
    ```

1. Confirm the Base Image is available

    ```
    $ docker images 
    REPOSITORY                 TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    levvel/rabbitclusterbase   latest              0a7f23864156        21 seconds ago      516.5 MB
    docker.io/centos           latest              ce20c473cd8a        2 weeks ago         172.3 MB
    $ 
    ```

1. Build the RabbitMQ Cluster Node Image


    ```
    $ ./2_build_cluster_node_image.sh 
    Building new Docker Cluster image(levvel/rabbitclusternode)
    Sending build context to Docker daemon 31.74 kB
    Step 0 : FROM levvel/rabbitclusterbase
    ---> bd61935b3201

    ... (skipping output to shorten README)

    Step 46 : CMD /opt/rabbit/startclusternode.sh
     ---> Running in 6317098abcb9
     ---> 439e59b05a5e
    Removing intermediate container 6317098abcb9
    Successfully built 439e59b05a5e
    $ 
    ```

1. Confirm the new RabbitMQ Cluster Node Image is available

  
    ```
    $ docker images
    REPOSITORY                 TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    levvel/rabbitclusternode   latest              439e59b05a5e        2 minutes ago       522.1 MB
    levvel/rabbitclusterbase   latest              bd61935b3201        36 minutes ago      522.1 MB
    docker.io/centos           latest              ce20c473cd8a        3 weeks ago         172.3 MB
    $ 
    ```

1. Start the Cluster


    ```
    $ ./3_start.sh
    Creating cluster_rabbit1_1...
    Creating cluster_rabbit2_1...
    Creating cluster_rabbit3_1...
    $

    ```

1. Confirm the RabbitMQ Cluster Docker Containers are available


    ```
    $ ./list_running_containers.sh 
    Docker Container Images
    CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                                                  NAMES
    d6187a4af7f9        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   6 seconds ago       Up 4 seconds        4369/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:1885->1883/tcp, 0.0.0.0:5674->5672/tcp, 0.0.0.0:8885->8883/tcp, 0.0.0.0:15674->15672/tcp   cluster_rabbit3_1
    d20c29edc4a1        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   7 seconds ago       Up 5 seconds        4369/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:1884->1883/tcp, 0.0.0.0:5673->5672/tcp, 0.0.0.0:8884->8883/tcp, 0.0.0.0:15673->15672/tcp   cluster_rabbit2_1
    9c1265c66284        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   7 seconds ago       Up 6 seconds        0.0.0.0:1883->1883/tcp, 0.0.0.0:5672->5672/tcp, 4369/tcp, 0.0.0.0:8883->8883/tcp, 9100-9105/tcp, 0.0.0.0:15672->15672/tcp, 25672/tcp   cluster_rabbit1_1
    $
    ```

1. Confirm the Cluster Status shows all Nodes are Runnning

    Note: this could take up to 30 seconds to register all Nodes. The first time running the cluster enables the RabbitMQ plugins.

    ```
    $ ./rst

    Running Cluster Status

    +----------------+------+---------+
    |      name      | type | running |
    +----------------+------+---------+
    | rabbit@rabbit1 | disc | True    |
    | rabbit@rabbit2 | ram  | True    |
    | rabbit@rabbit3 | disc | True    |
    +----------------+------+---------+

    $
    ```

1. SSH into a Node

    ```
    $ ./ssh_node_2.sh 
    SSHing into cluster_rabbit2_1
    [root@rabbit2 /]#
    ```

1. From inside the SSH session running on the Node confirm the Cluster Status

    ```
    [root@rabbit2 /]# rst 

    Cluster status of node rabbit@rabbit2 ...
    [{nodes,[{disc,[rabbit@rabbit3,rabbit@rabbit1]},{ram,[rabbit@rabbit2]}]},
     {running_nodes,[rabbit@rabbit3,rabbit@rabbit1,rabbit@rabbit2]},
     {cluster_name,<<"rabbit@rabbit1">>},
     {partitions,[]}]

    [root@rabbit2 /]# 
    ```

    ```
    [root@rabbit2 /]# exit
    $
    ```

1. Stop a Node from outside the Docker Containers

  
    ```
    $ ./end_node_2.sh 
    Ending rabbit2 with command: pushd cluster ; docker-compose stop rabbit2 ; popd
    Stopping cluster_rabbit2_1... done
    $
    ```

1. Confirm Node 2 is no longer running at the Container level

    ```
    $ ./list_running_containers.sh 
    Docker Container Images
    CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS                        PORTS                                                                                  NAMES
    d6187a4af7f9        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   About a minute ago   Up About a minute            4369/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:1885->1883/tcp, 0.0.0.0:5674->5672/tcp, 0.0.0.0:8885->8883/tcp, 0.0.0.0:15674->15672/tcp   cluster_rabbit3_1
    d20c29edc4a1        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   About a minute ago   Exited (137) 3 seconds ago                                                                                                                                          cluster_rabbit2_1
    9c1265c66284        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   About a minute ago   Up About a minute            0.0.0.0:1883->1883/tcp, 0.0.0.0:5672->5672/tcp, 4369/tcp, 0.0.0.0:8883->8883/tcp, 9100-9105/tcp, 0.0.0.0:15672->15672/tcp, 25672/tcp   cluster_rabbit1_1
    $
    ```

1. Confirm Node 2 is no longer running at the Cluster level

    ```
    $ ./rst 

    Running Cluster Status

    +----------------+------+---------+
    |      name      | type | running |
    +----------------+------+---------+
    | rabbit@rabbit1 | disc | True    |
    | rabbit@rabbit2 | ram  | False   |
    | rabbit@rabbit3 | disc | True    |
    +----------------+------+---------+

    $
    ```

1. Start Node 2

    ```
    $ ./start_node_2.sh 
    Starting rabbit2 with command: pushd cluster ; docker-compose start rabbit2 ; popd
    Starting cluster_rabbit2_1...
    $
    ```

1. Confirm Node 2 is running at the Container level

    ```
    $ ./list_running_containers.sh 
    Docker Container Images
    CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                                                  NAMES
    d6187a4af7f9        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   About a minute ago   Up About a minute   4369/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:1885->1883/tcp, 0.0.0.0:5674->5672/tcp, 0.0.0.0:8885->8883/tcp, 0.0.0.0:15674->15672/tcp   cluster_rabbit3_1
    d20c29edc4a1        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   About a minute ago   Up 2 seconds        4369/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:1884->1883/tcp, 0.0.0.0:5673->5672/tcp, 0.0.0.0:8884->8883/tcp, 0.0.0.0:15673->15672/tcp   cluster_rabbit2_1
    9c1265c66284        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   About a minute ago   Up About a minute   0.0.0.0:1883->1883/tcp, 0.0.0.0:5672->5672/tcp, 4369/tcp, 0.0.0.0:8883->8883/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp   cluster_rabbit1_1
    $
    ```

1. Confirm Node 2 is running at the Cluster level

    ```
    $ ./rst 

    Running Cluster Status

    +----------------+------+---------+
    |      name      | type | running |
    +----------------+------+---------+
    | rabbit@rabbit1 | disc | True    |
    | rabbit@rabbit2 | ram  | True    |
    | rabbit@rabbit3 | disc | True    |
    +----------------+------+---------+

    $
    ```

1. View All Cluster Exchanges

    ```
    $ ./exchanges.sh 

    Displaying Cluster Exchanges

    +--------------------+---------+---------+-------------+----------+--------+-------+-----------+
    |        name        |  type   | durable | auto_delete | internal | policy | vhost | arguments |
    +--------------------+---------+---------+-------------+----------+--------+-------+-----------+
    |                    | direct  | True    | False       | False    |        | /     |           |
    | amq.direct         | direct  | True    | False       | False    |        | /     |           |
    | amq.fanout         | fanout  | True    | False       | False    |        | /     |           |
    | amq.headers        | headers | True    | False       | False    |        | /     |           |
    | amq.match          | headers | True    | False       | False    |        | /     |           |
    | amq.rabbitmq.log   | topic   | True    | False       | True     |        | /     |           |
    | amq.rabbitmq.trace | topic   | True    | False       | True     |        | /     |           |
    | amq.topic          | topic   | True    | False       | False    |        | /     |           |
    +--------------------+---------+---------+-------------+----------+--------+-------+-----------+

    $
    ```

1. View All Cluster Queues

    ```
    $ ./queues.sh 

    Displaying Cluster Queues

    No items

    $
    ```

1. View All Cluster Bindings

    ```
    $ ./bindings.sh 

    Displaying Cluster Bindings

    No items

    $
    ```

### Starting the Cluster

1. You can start the Cluster Docker Containers by running this command:

    ```
    $ ./3_start.sh 
    Starting cluster_rabbit1_1...
    Starting cluster_rabbit2_1...
    Starting cluster_rabbit3_1...
    $
    ```

1. Confirm the Containers are running:

    ```
    $ ./list_running_containers.sh 
    Docker Container Images
    CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                                                  NAMES
    d6187a4af7f9        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   5 minutes ago       Up 40 seconds       4369/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:1885->1883/tcp, 0.0.0.0:5674->5672/tcp, 0.0.0.0:8885->8883/tcp, 0.0.0.0:15674->15672/tcp   cluster_rabbit3_1
    d20c29edc4a1        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   5 minutes ago       Up 40 seconds       4369/tcp, 9100-9105/tcp, 25672/tcp, 0.0.0.0:1884->1883/tcp, 0.0.0.0:5673->5672/tcp, 0.0.0.0:8884->8883/tcp, 0.0.0.0:15673->15672/tcp   cluster_rabbit2_1
    9c1265c66284        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   5 minutes ago       Up 41 seconds       0.0.0.0:1883->1883/tcp, 0.0.0.0:5672->5672/tcp, 4369/tcp, 0.0.0.0:8883->8883/tcp, 9100-9105/tcp, 0.0.0.0:15672->15672/tcp, 25672/tcp   cluster_rabbit1_1
    $
    ```

1. Confirm the Cluster Status:

Note: The cluster will take a few moments to join and sync together. You may see the 'running' field go between False and True a couple times while it stabilizes.  

Once the cluster is completes initializing the output will look like:

    ```
    $ ./rst 

    Running Cluster Status

    +----------------+------+---------+
    |      name      | type | running |
    +----------------+------+---------+
    | rabbit@rabbit1 | disc | True    |
    | rabbit@rabbit2 | ram  | True    |
    | rabbit@rabbit3 | disc | True    |
    +----------------+------+---------+

    $
    ```

### Stopping the Cluster

1. When you want you can stop the Cluster Docker Containers by running this command:

    ```
    $ ./4_stop.sh 
    Stopping cluster_rabbit3_1... done
    Stopping cluster_rabbit2_1... done
    Stopping cluster_rabbit1_1... done
    $
    ```

1. Confirm the Cluster Docker Containers are not running:

    ```
    $ ./list_running_containers.sh 
    Docker Container Images
    CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS                            PORTS               NAMES
    d6187a4af7f9        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   4 minutes ago       Exited (137) 33 seconds ago                       cluster_rabbit3_1
    d20c29edc4a1        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   4 minutes ago       Exited (137) 33 seconds ago                       cluster_rabbit2_1
    9c1265c66284        levvel/rabbitclusternode   "/bin/sh -c /opt/rabb"   4 minutes ago       Exited (137) 33 seconds ago                       cluster_rabbit1_1
    $
    ```

Troubleshooting
------------------

1. General Docker Debugging when a Container starts but almost immediately stops

    One of the harder debugging tasks is trying to debug a Docker Container that fails to stay up more than a few seconds. By default on startup each RabbitMQ Container will run the file: server/startclusternode.sh When this file runs I found it useful to add logging to each step in the process to see how far the Container was able to get on startup. You can view the logs are stored in the Container with the command ```rl``` or by logging in and running: 

    ```
    cat /tmp/rabbitnode.log  
    ```

    Additionally you can run a Docker Container and login to it from a non-running state with the command:

    ```
    docker run -it <image name or container ID> bash
    ```

    This allows you to run commands while inside the Container.

1. Using the tl command

    I find viewing and actively tailing the RabbitMQ logs that are stored in /var/log/rabbitmq/* beneficial to watch when I am debugging. This is included in each RabbitMQ container and set as an executable script at: /bin/tl  

1. Using the rl command

    The Container runs the server/startclusternode.sh script which logs progress information to the /tmp/rabbitnode.log file. The ```rl``` command is installed on each Container for quickly viewing issues with starting a cluster node. Under the hood this is doing a ```tail -f /tmp/rabbitnode.log```

1. Be careful with running ```/usr/sbin/rabbitmqctl reset``` and ```/usr/sbin/rabbitmqctl force_reset``` 

    I have seen errors where the next time I tried to start a node, the cluster thinks it has already joined. If this happens, I had to delete the Container images and start over using the 'Cleanup the Cluster' steps.

1. Waiting for the cluster to stabilize on a Start

    Starting the cluster the first time can take up to 30 seconds. Starting the cluster from a stopped state can take about 15 seconds. Please be patient, this is due to the initialization of the containers and then coordination between the brokers. Additionally, the first time the cluster starts it will enable the RabbitMQ plugins on each node and then allow the master node (rabbit1) to start first before they attempt to join the cluster.

1. Installing the RabbitMQ Admin command line interface

    Please refer to the RabbitMQ guide on how to install the rabbitmqadmin cli:
    https://www.rabbitmq.com/management-cli.html

Cleanup the Cluster
----------------------

1. Please be careful, this will delete all your local Docker Containers and Images

    ```
    $ ./4_stop.sh 
    Stopping cluster_rabbit3_1... done
    Stopping cluster_rabbit2_1... done
    Stopping cluster_rabbit1_1... done
    $ cd _destroy_all_local_containers
    $ ./destroy_all_containers.sh 

    Destroying containers:
    cluster_rabbit3_1
    cluster_rabbit2_1
    cluster_rabbit1_1
    Done destroying containers

    Destroying all images
    Error response from daemon: No such image: IMAGE
    Untagged: levvel/rabbitclusternode:latest
    Deleted: 2f78a96647abcacfb09faf85a52206015ddb967c526d159b7d32f5efc9011a77
    Deleted: b4e42437a6277655c6033503837c44b953bb05016b055c5aabf593aec1087c49

    ... (skipping output to shorten README)

    Error response from daemon: No such image: 168a69b62202
    Error response from daemon: No such image: 47d44cb6f252
    Error: failed to remove images: [IMAGE 415e4451dfeb 003f032d4403 73619cc4805b 31905459b9a4 6e477268d993 3e3b61868fcd 1cf72712798e f7cd42365347 4203c6d86757 7cd157ace404 16733c2834dd e53d49656cae 6a7c06c65163 9277140c30c6 c1918dd963aa bbd3aa35317c 119e4f0415f6 e5ec4ab9df07 698ce8dc430f bc3e57e5caf1 947217441d74 b7ec05d36012 4d199ca9aabd c4106017430f e6152dc088f2 50d7afb1da90 31e5e63d2cc4 26217edb3c66 223181a571d6 176a41fc47fc 02878980f91e ddef51b6b5da 812e9d9d677f 4234bfdd88f8 168a69b62202 47d44cb6f252]
    Done all images
    $
    ```

1. Confirm Docker Images and Docker Containers are empty

    ```
    $ docker images -a
    REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    $
    ```

    ```
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    $
    ```

    ```
    $ ./list_running_containers.sh 
    Docker Container Images
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    $
    ```

Resources
------------

This repository was created from extending these Fedora single instance Docker containers running on Fedora 22:

  https://github.com/fedora-cloud/Fedora-Dockerfiles/tree/master/rabbitmq

  https://github.com/projectatomic/docker-fedora-images/tree/master/rabbitmq

After encountering errors with Fedora 22 and trying to get the RabbitMQ broker to cluster using individual containers and link (without compose), I decided to try and find an alternative. I started looking for existing CentOS Docker RabbitMQ examples and luckily found there was a starter example. Thanks to Biju Kunjummen for getting a sample compose yml file:

  https://github.com/bijukunjummen/docker-rabbitmq-cluster

Contributing
---------------

This section gives an overview of how to contribute.

#### Pull requests are always welcome

We will appreciate any contributions no matter how small. Your time is valuable so thank you in advance. We are always excited to receive pull requests, and we do our best to process them quickly. 

Any significant improvement should be documented as a GitHub issue before anybody starts working on it. This will help us coordinate, track and prioritize development.

Here is a general way to contribute:

1. Fork this repository to your GitHub account
1. Clone the Fork repository
1. Create a feature branch off master
1. Commit changes and tests to the feature branch
1. When the code is ready, open a Pull Request for merging your Fork's feature branch into master
1. We will review the Pull Request and address any questions in the comments section of the Pull Request
1. After an initial "Looks Good", we will initiate a regression test where the feature branch is applied to master and confirm nothing breaks
1. If something breaks we will add comments to the Pull Request documenting the failure and help work through solutions with you
1. Once everything passes we will merge your feature branch into master

License
----------

  Apache 2.0 License

  Copyright 2015 Levvel LLC

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.


