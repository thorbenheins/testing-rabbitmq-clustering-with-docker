Message Simulations for RabbitMQ Clusters
===========================================

These directories contain testing simulations for helping validate that a RabbitMQ Cluster can support High Availability, Load, Stress, and Burst message requirements.

Message simulations are modeled as JSON configuration files and outline a test's: producers, consumers, test resources, configuration, exchanges, queues, bindings, and message sets. Each Message Simulation JSON file is organized with a common hierarchy:

Simulation
  - Rabbit connection information
  - Consumers to independently spawn off as separate processes
  - BrokerEntities to create for this simulation
    - Exchanges - list of Exchanges with RabbitMQ attributes
    - Queues - list of Queues with RabbitMQ attributes
    - Bindings - list of Bindings for message routings
    - Messages - list of templated definitions for producting and consuming sets of messages

### Overview

Testing that your RabbitMQ cluster's configuration, hardware, network, clients (producers and consumers), and monitoring will be able to support your production traffic is a complex task requiring expertise beyond just the core RabbitMQ technology. These message simulations are a few common scenarios for helping you fine-tune and optimize your cluster.

Included Traffic Model Use Cases:

1. Load
1. HA (High Availability) 
1. Stress
1. Burst (Coming Soon)

Getting Started
---------------

#### Setup and Installation

The Message Simulator has only been validated on Fedora 22.

1. To setup your local Docker RabbitMQ Cluster please refer to:

  https://github.com/GetLevvel/testing-rabbitmq-clustering-with-docker

1. Please make sure to the go through the [Networking](https://github.com/GetLevvel/message-simulator#networking) section for how to use the Message Simulator with your local Docker RabbitMQ Cluster:

  https://github.com/GetLevvel/message-simulator

1. These repositories can be cloned locally to any directory, but for simplifying the documentation we will assume they are cloned to the same parent directory ```/opt``` so that by running the command ```ls /opt``` the two repositories appear in the directory like:

  ```
  $ git clone https://github.com/GetLevvel/testing-rabbitmq-clustering-with-docker.git /opt/
  ```

  ```
  $ git clone https://github.com/GetLevvel/message-simulator.git /opt/
  ```

  ```
  $ ls /opt
  message-simulator  testing-rabbitmq-clustering-with-docker
  $ 
  ```

1. Start your cluster with the script: 
  
  https://github.com/GetLevvel/testing-rabbitmq-clustering-with-docker/blob/master/3_start.sh

1. Confirm you can connect to your Docker cluster as ```rabbit1```

  ```
  $ telnet rabbit1 5672
  Trying 127.0.0.1...
  Connected to rabbit1.
  Escape character is '^]'.
  ^] 

  telnet> quit
  Connection closed.
  $
  ```

1. Confirm the Docker cluster responds with all members report back that they are running:

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

#### Using the Message Simulator

1. Command Line Usage

  For now, the Message Simulator can only be invoked from the command line. To use it please provide the arguments below:

  ```
  /opt/message-simulator/run_message_simulation.py -f <Simulation File> 
  ```

  The Simulator also supports an optional debug flag ```-d``` which can be provided on the command line:

  ```
  /opt/message-simulator/run_message_simulation.py -f <Simulation File> -d
  ```

1. Logs

  The Message Simulator logs to /var/log/messages. To watch the logs as the Simulator runs please use the command:

  ```
  tail -f /var/log/messages
  ```


#### Validating the Message Simulator is ready

The Message Simulator comes with a set of validation tests that are used to check the systems are ready.

1. Run the Hello World example with the command:

  ```
  $ /opt/message-simulator/run_message_simulation.py -f /opt/testing-rabbitmq-clustering-with-docker/test_simulations/setup_validation/docker_cluster_hello_world.json 

  Running Simulation(/opt/testing-rabbitmq-clustering-with-docker/test_simulations/setup_validation/docker_cluster_hello_world.json)

  Done Waiting for Messages(1)

  Running Connector Summary

  Checking Exchanges(8)
    Exchange({'VHost': '/', 'Internal': 'False', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'Hello.Ex', 'Policy': '', 'Durable': 'False', 'Type': 'topic'})
    Exchange({'VHost': '/', 'Internal': 'False', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'amq.direct', 'Policy': '', 'Durable': 'True', 'Type': 'direct'})
    Exchange({'VHost': '/', 'Internal': 'False', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'amq.fanout', 'Policy': '', 'Durable': 'True', 'Type': 'fanout'})
    Exchange({'VHost': '/', 'Internal': 'False', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'amq.headers', 'Policy': '', 'Durable': 'True', 'Type': 'headers'})
    Exchange({'VHost': '/', 'Internal': 'False', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'amq.match', 'Policy': '', 'Durable': 'True', 'Type': 'headers'})
    Exchange({'VHost': '/', 'Internal': 'True', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'amq.rabbitmq.log', 'Policy': '', 'Durable': 'True', 'Type': 'topic'})
    Exchange({'VHost': '/', 'Internal': 'True', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'amq.rabbitmq.trace', 'Policy': '', 'Durable': 'True', 'Type': 'topic'})
    Exchange({'VHost': '/', 'Internal': 'False', 'Arguments': '', 'AutoDelete': 'False', 'Exchange': 'amq.topic', 'Policy': '', 'Durable': 'True', 'Type': 'topic'})

  Checking Queues(1)
    Queue({'Consumers': '0', 'Durable': 'False', 'ConsumerUtilization': '', 'MsgsReadyRam': '0', 'State': 'running', 'Arguments': '', 'Memory': '26792', 'Policy': '', 'MsgsRam': '0', 'MsgsReady': '0', 'MsgsPersistent': '0', 'Node': 'rabbit@rabbit1', 'PID': '', 'SyncSlaveNodes': '', 'MsgsBytes': '0', 'Name': 'hello', 'AutoDelete': 'False', 'ExclusiveConsumerTag': '', 'Msgs': '0', 'SlaveNodes': '', 'ExclusiveConsumerPID': '', 'OwnerPID': '', 'MsgsUnacked': '0'})

  Checking Bindings(2)
    Binding Ex(Default) => Queue(hello) RoutingKey(hello)
    Binding Ex(Hello.Ex) => Queue(hello) RoutingKey(example.text)

  Checking Nodes(3)
    Node({'Uptime': '', 'Processors': '208', 'SocketsUsed': '943626', 'FDUsed': '1048576', 'RunQueue': '2', 'Memory': '24', 'Type': 'rabbit@rabbit1', 'Name': '', 'StatsLevel': '3', 'SocketsTotal': 'True', 'FDs': '51964156', 'ProcTotal': 'disc', 'Running': '0', 'ProcUsed': '1048576'})
    Node({'Uptime': '', 'Processors': '204', 'SocketsUsed': '943626', 'FDUsed': '1048576', 'RunQueue': '2', 'Memory': '23', 'Type': 'rabbit@rabbit2', 'Name': '', 'StatsLevel': '3', 'SocketsTotal': 'True', 'FDs': '51967703', 'ProcTotal': 'ram', 'Running': '0', 'ProcUsed': '1048576'})
    Node({'Uptime': '', 'Processors': '207', 'SocketsUsed': '943626', 'FDUsed': '1048576', 'RunQueue': '2', 'Memory': '26', 'Type': 'rabbit@rabbit3', 'Name': '', 'StatsLevel': '3', 'SocketsTotal': 'True', 'FDs': '51883559', 'ProcTotal': 'disc', 'Running': '0', 'ProcUsed': '1048576'})

  Done Simulation(/opt/testing-rabbitmq-clustering-with-docker/test_simulations/setup_validation/docker_cluster_hello_world.json)

  $
  ```

#### How Simulations work

Please refer to the How Simulations Work section in the Message Simulator Guide
https://github.com/GetLevvel/message-simulator#how-simulations-work

