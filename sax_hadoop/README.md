sax_hadoop Cookbook
===================
TODO: This cookbook will install Hadoop on a single node as well as in distributed nodes.


Attributes
----------

Update the attribute files accordingly.

1. default['sax_hadoop']['hadoop_tar_path'] --> Location of Hadoop Tar
2. default['sax_hadoop']['hdp_install_loc'] --> Hadoop Installation Location
3. default['sax_hadoop']['hadoop_untar_bashrc'] --> Untar path of Hadoop. This attribute must be used for any ".bashrc" updation because the value will have esacape characters '\'
4. default['sax_hadoop']['hadoop_untar'] --> The value of this attribute and ['hadoop_untar_bashrc'] are same but here the escape characters won't be there. Use this only if you are not manipulating ".bashrc"
5. default['sax_hadoop']['username_for_ssh'] --> Provide the username for performing ssh

Usage

-----
#### To run on single node (fresh install on node)
1. Bootstrap "default.rb"
2. Bootstrap "start_all.rb" if you want to start all Hadoop Process
3. Bootstrap "stop_all.rb" if you want to stop all Hadoop Process.

NOTE - Don't bootstrap "default.rb" again. Because it will format namenode and other services like datanode wont come up.


#### To run on Distributed Mode (fresh install on nodes)
1. Update the "slaves" part in default.rb file
2. Change the dfs replication value in attributes/default.rb
3. Bootstrap slave node(s) first and run "hadoop_dist.rb" first. It will install hadoop on the slave nodes and set the config files.
4. Bootstrap "default.rb"
5. Bootstrap "start_all.rb" if you want to start all Hadoop Process
6. Bootstrap "stop_all.rb" if you want to stop all Hadoop Process. 

NOTE - Don't bootstrap "default.rb" again. Because it will format namenode and other services like datanode wont come up.

License and Authors
-------------------

Authors: SAX_DEVOPS TEAM
Company: Impetus Infotech Pvt. LTD.
