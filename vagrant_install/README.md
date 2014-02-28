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


Loading Data in the Virtual Machine
============================================

#### Approach

Generally, we used an asynchronous approach for loading datasets/linksets into the system. This means that the loading process is essentially made of 2 stages. 
First, queue the datasets/linksets which we want to load, then trigger the actual loading process. This approach gives the API user the option of triggering 
the loading process at a moment when network traffic is more convenient or when the load on the system is at a minimum. 

And since the datasets and linksets go to different components of the system, the loading of datasets can be triggered separately from loading of linksets 
(2 different API calls). 

For checking the progress of the loading process, an additional API call is provided which shows the loading status of all the datasets and linksets in the system.


#### Loading Steps

A concrete step-by-step workflow would look like this:
1. Use the "/load" API call to *queue* the dataset and linkset dumps from a VOID header for loading. 

The API call expects 2 parameters the VOID uri and the graph name where the datasets will be loaded in the triplestore.
Example: 
    http://localhost/load?uri=https%3A%2F%2Fraw.github.com%2Fopenphacts%2Fops-platform-setup%2FseverVOIDs%2Fvoid%2Fchembl%2Fchembl16-void.ttl&graph=http%3A%2F%2Fwww.ebi.ac.uk%2Fchembl

2. Repeat 1. for all the available VOID headers.
3. Use the API call "/triggerDatasetLoading" to start loading datasets in the triplestore. This call will effectively go trough all the data dumps which appear
in the VOID headers submitted so far, download them, unarchive them if needed and load each data file into its corresponding graph, as specified in step 1.
4. Use the API call "/triggerLinksetLoading" to start loading linksets in the IMS (can be done in parallel with 3). Similar to 3, this will go through all
the linkset dumps, download them, unarchive if necessary, and load them into the IMS.
5. Check progress while loading using "/getLoadingStatus" . Separate loading statuses are maintained for datasets and linksets, since they are different processes.
In addition, we have a loading status at 2 levels of granularity: a loading status per VOID URI and a loading status for each dataset/linkset dump. There are 
4 possible loading states: QUEUED (until 3 or 4 is executed), LOADING (while actually loading), LOADED(successfull loading attempt), 
LOADING_ERROR (unsuccessfull loading attempt).
6. Optionally, after 4 is completed, call "/triggerTransitivesComputation" to start the computation of transitives in the IMS.

#### Handling Loading Failures

### Datasets

During the loading process, we take checkpoints after loading in Virtuoso all the dataset dumps from a VOID header. So if one of the dumps is not successfully 
loaded, we revert to the previous checkpoint and then move to the next VOID header. This means that if one of the data dumps in a VOID header fails to load,
all data dumps from that VOID header will get the status LOADING_ERROR. An error message will be provided via the "getLoadingStatus" API call, which will give
a reason for the loading failure. After fixing the problematic data dumps, the associated VOID headers have to be re-queued via the "/load" API call, then 
the loading process can be triggered again. 

### Linksets

The IMS sequentially loads each linkset dump. If one of the linkset dumps fail, it will get a LOADING_ERROR status, with an associated error message. Then, the
process continues loading the remaining linksets. After fixing the problematic linksets, their associated VOID headers have to be re-queued via the "/load" API
call and then linkset loading process triggered again. This will only re-load the problematic linksets (which had a LOADING_ERROR status), the ones successfully 
loaded in previous attempts will not be re-loaded.







