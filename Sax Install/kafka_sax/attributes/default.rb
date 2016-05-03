default['kafka_sax']['source'] = 'http://172.25.39.15/StreamAnalytix-Chef-Automation/files/Kafka/kafka_2.9.2-0.8.1.1.tgz'
default['kafka_sax']['install_path'] = '/home/sax/install'
default['kafka_sax']['owner'] = 'sax'
default['kafka_sax']['password'] = 'sax'
default['kafka_sax']['group'] = 'sax'
default['kafka_sax']['mode'] = '0755'
default['kafka_sax']['sax_home'] = '/home/sax'

default['kafka_sax']['hostname'] = 'impetus15.impetus.co.in'
default['kafka_sax']['zk_ip'] = ['impetus14.impetus.co.in', 'impetus15.impetus.co.in', 'impetus16.impetus.co.in']
