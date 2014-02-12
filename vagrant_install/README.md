OPS Deploy in a Virtual Machine
============================================

#### Setup

- Install VirtualBox https://www.virtualbox.org/wiki/Downloads (On Ubuntu: sudo apt-get install virtualbox)
- Download Vagrant installer from http://www.vagrantup.com/downloads ([Vagrant Documentation](http://docs.vagrantup.com/v2/) )
- git clone https://github.com/openphacts/ops-platform-setup.git
- cd ops-platform-setup/vagrant_install
- vagrant up (this first time this will download a VM image, so for a fast install it should be done over an Ethernet connection).

To check the system has been successfully set up, the following pages should provide interfaces to each subsystem:
- http://localhost:4500
- http://localhost:4501/QueryExpander/mapURI
- http://localhost:4502/sparql

Behind the scenes this will create a VM Box which contains the 3 OPS platform subsystems: 
- the Linked Data API(default port 4500)
- the IMS (default port 4501)
- the Virtuoso RDF store(default port 4502)

#### Default configs

The default host ports can be changed from the Vagrantfile though the "config.vm.network" setting

The machine settings of the VM can also be customized in the "config.vm.provider :virtualbox" section of the Vagrantfile.
The default memory requirements for the VM are 1.5 GB RAM. The default CPU provided is 100%.  


#### Other commands

To save the current VM state and suspend: 

    vagrant suspend

To delete the VM from disk (this will not delete the downloaded base VM image): 

    vagrant destroy

To reboot: 

    vagrant up
