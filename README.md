ops-platform-setup
==================
This repository is designed to collect all information needed to set up the Open Phacts platform. The aim is to be able to pull directly pull from github and in one go setup a running version of Open Phacts. Hopefully, this will include not only the core cache but also the other required services Something all the lines of how [Heroku](https://devcenter.heroku.com/articles/git ) leverages git. In the meantime, using github will allow us to keep our documentation reasonably up-to-date as we develop.

Core Platform TODOs
-------------------
In JIRA at <https://openphacts2011.atlassian.net/secure/IssueNavigator.jspa?mode=hide&requestId=10701>

Code
--------------

Source code needed

- <https://larkc.svn.sourceforge.net/svnroot/larkc/trunk>
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
For each hierarchy we have three named graphs

1. the direct hierarchy - the named graph is denoted by /direct
2. the full closure - the named graph is denoted by /inference
3. other info (e.g. rdfs:label) - the named graph without a suffix

### Platform set-up on ops2 (CentOS 6.2), 10 Aug 2012

#### Load data into Virtuoso
    
#### Set up LDA

    [antonis@ops2 ~]$ sudo yum install php
    [antonis@ops2 ~]$ sudo yum install php-xml
    [antonis@ops2 ~]$ sudo chmod -R go+rw /var/www
    [antonis@ops2 ~]$ cd /var/www/
    [antonis@ops2 www]$ rmdir html
    [antonis@ops2 www]$ git clone https://github.com/openphacts/OPS_LinkedDataApi.git html

    Edit: /etc/httpd/conf/httpd.conf
    You need .htaccess files enabled and allowed on DOCUMENTROOT

    AccessFileName .htaccess

    <Directory "/var/www/html">
        Options Indexes FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

    [antonis@ops2 ~]$ service httpd start

#### Steps to enable caching from RAM instead of disk
1. Edit deployment.settings.php from the root of LDA and change:

  define('PUELIA_SERVE_FROM_CACHE', true);

to

  define('PUELIA_SERVE_FROM_CACHE', true);

2. yum install php-pecl-memcache

3. yum install memcached

4. Add to php.ini:

  extension=memcache.so

5. Add to/Create /etc/httpd/conf.d/memcached.conf 

  <IfModule mod_memcached_cache.c>
        CacheEnable memcached /
        MemcachedCacheServer localhost:11211
        MemcachedMaxServers 50
        MemcachedMinConnections 10
        MemcachedSMaxConnections 100
        MemcachedMaxConnections 100
        MemcachedConnectionTTL 10
        MemcachedCacheMinFileSize 1
        MemcachedCacheMaxFileSize 20971520
        CacheDisable /admin/
  </IfModule>

6. Make sure the request Header does not contain the option 'cache-control=no-cache'
