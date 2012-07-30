ops-platform-setup
==================
This repository is designed to collect all information needed to set up the Open Phacts platform. The aim is to be able to pull directly pull from github and in one go setup a running version of Open Phacts. Hopefully, this will include not only the core cache but also the other required services Something all the lines of how [Heroku](https://devcenter.heroku.com/articles/git ) leverages git. In the meantime, using github will allow us to keep our documentation reasonably up-to-date as we develop.

Core Platform TODOs
-------------------
In JIRA at <https://openphacts2011.atlassian.net/secure/IssueNavigator.jspa?mode=hide&requestId=10701>

Code
--------------

Source code needed

- <https://github.com/openphacts/OpsPlatform>
- <https://github.com/openphacts/coreGUI>
- <https://github.com/openphacts/OPS_LinkedDataApi>


Software
----------------
- Tomcat 6
- Apache 2
- [Sesame 2.6.8](http://www.openrdf.org/)

Data
---------------
- Data loading script is in scripts/seasame-load-list.txt
- Run using console.sh < sesame-load-list.txt
- Each dataset is loaded into a separate named graph

#### Hierarchies
For each hierarchy we have two named graphs

1. the direct hierarchy - the named graph is denoted by /direct
2. the full closure - the named graph is denoted by /inference


Environment Setup (Current)
-----------------

We use screen

Directory setup

    /var/www                  #lda is here
    /var/www/api-config-files # sparql files for lda located here
    ~/
    ~/log/                    # logs are stored here
    ~/production/             # contains OpsPlatform code for production
    ~/develop/                # contains OpsPlatform code for develop
    ~/coreGUI/                # contains core GUI code for running the explorer

- One RDF store (sesame) running on 9090
-- http://ops.few.vu.nl:9090/openrdf-workbench/
- data is located at ~/develop/openphacts/datasets
- We are currently running all data off one endpoint

#### Building Base Platform
    OPS@ops:~/production/openphacts/ops-platform/scripts$ source BuildLarKC.sh 
    OPS@ops:~/develop/openphacts/ops-platform/scripts$ source BuildLarKC.sh 

#### Core API LarKC instance
     
     OPS@ops:~$ screen -x 4444
     OPS@ops:~/production/openphacts/ops-platform/scripts$ source RunLarKC.sh &> ~/log/production.log
     # exit out of screen
     # and launch the workflow
     OPS@ops:~/production/openphacts/ops-platform/scripts$ source  ExportOPSVariables.sh
     OPS@ops:~/production/openphacts/ops-platform/scripts$ source LaunchOPSAPIWorkflow.sh

Note that ~/production/larkc-endpoints/endpoint.opsapi/src/main/java/eu/larkc/endpoint/opsapi/sparql/ contains the sparql queries being run by the core api. These are before expansion.


#### Linked Data API LarKC instance

    OPS@ops:~$ screen -x 6858
    OPS@ops:~/develop/openphacts/ops-platform/scripts$ source RunLarKC.sh &> ~/log/develop.log
    # exit out of screen
    # and launch the workflow
    OPS@ops:~/develop/openphacts/ops-platform/scripts$ source  ExportOPSVariables.sh
    OPS@ops:~/develop/openphacts/ops-platform/scripts$ source Launch_LDA_Workflow.sh

###### LDA queries
- all queries are in api-config-files
- the difference between github and server is the port of where the lark endpoint is located
- sparqlEndpoint  api:sparqlEndpoint <http://localhost:9183/sparql/> ;
- to update the lda queries you just need to modify the queries
- can test by checking out and using the ops machine
- by convention, in the lda in sparql variables names ?ops_item are replaced by the uri of post variable
- ops:input tells the expander what to expand on 

#### Launch GUI
  
     OPS@ops:~/coreGUI$ screen -x 21619
     rails s -e production  &> ~/log/gui2.log


