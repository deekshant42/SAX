default['sax_hadoop']['source'] = 'http://172.25.39.15/StreamAnalytix-Chef-Automation/files/Hadoop/hadoop-2.6.0.tar.gz'

default['sax_hadoop']['owner'] = 'sax'
default['sax_hadoop']['group'] = 'sax'
default['sax_hadoop']['mode'] = '0755'

default['sax_hadoop']['hadoop_install_loc'] = '/home/sax/install' #This path should preferably be inside the home directory of the user above specified

######## SLAVES ###################

default['sax_hadoop']['master_fqdn'] = 'impetus14.impetus.co.in'
default['sax_hadoop']['slaves_fqdn'] = ['impetus15.impetus.co.in', 'impetus16.impetus.co.in'] #Array of slave hostnames 


######### HDFS-SITE.XML#############

default['sax_hadoop']['dfs_replication_value'] = '2' #Rep factor should be less than or equal to no. of slaves. 

########## CORE-SITE.XML############

#default['sax_hadoop']['master_IP_addr'] = ''
default['sax_hadoop']['core_port_no'] = '9000'

########## YARN-SITE.XML############

default['sax_hadoop']['web_proxy_add_port'] = '8035'
default['sax_hadoop']['resourcemanager_add_port'] = '8032'
default['sax_hadoop']['resourcemanager_res_tracker_port'] = '8031'
default['sax_hadoop']['resourcemanager_sched_add_port'] = '8030'

########################################




default['sax_hadoop']['username'] = 'sax'  #Eg: username@127.0.0.1 with this user your hadoop services will be run

default['sax_hadoop']['user_pwd'] = 'sax'
