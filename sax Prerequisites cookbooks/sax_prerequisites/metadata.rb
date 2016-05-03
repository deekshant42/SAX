name             'sax_prerequisites'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures sax_prerequisites'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

#depends 'hostfile','~> 0.1.0'
depends 'sax_os_packages','~> 0.1.0'
depends 'firewall_disable','~> 0.1.0'
depends 'selinux_disable','~> 0.1.0'
depends 'default_requiretty','~> 0.1.0'
depends 'sax_users','~> 0.1.0'
depends 'install_java','~> 0.1.0'

