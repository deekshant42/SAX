default['install_java']['source'] = 'http://172.25.39.15/StreamAnalytix-Chef-Automation/files/java/jdk-7u71-linux-x64.tar.gz'
default['install_java']['install_path'] = '/usr/lib/jvm/'
default['install_java']['owner'] = 'sax'
default['install_java']['group'] = 'root'
default['install_java']['pwd'] = 'sax'
default['install_java']['mode'] = '0755'
default['install_java']['home_path'] = '/home/sax/'
default['install_java']['java_tar_path'] = '/usr/lib/jvm/jdk-7u71-linux-x64.tar.gz'
default['install_java']['java_home'] = '/usr/lib/jvm/jdk1.7.0_71'
default['install_java']['java_path'] = '/home/sax/.bashrc'
default['install_java']['username_for_ssh'] = 'sax'
default['install_java']['ip_to_source'] = node['fqdn']

