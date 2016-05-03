
This cookbook will install JAVA on the node



------------
Requirements
-------------
1. Openssl Cookbook
2. Chef-Sugar Cookbook
3. Dependancy entry needed in "metadeta.rb" and "Berksfile"

Note - Perform "sudo berks install" to get the above cookbooks and upload using "sudo berks upload --no-ssl-verify" before bootstrapping

Usage
-----
1. Update the attributes accordingly.
2. To set the password attribute "default['install_java']['pwd']", you need to run this command --> openssl passwd -1 "your_new_password" in the terminal and copy the encrypted value and paste it as the value of attribute.
3. If you are bootstrapping a particular IP, you need to give the same IP for this attribute --> default['install_java']['ip_to_source'] 


Authors
-------------------
Authors: SAX DevOps Team
Company: Impetus Infotech Pvt. LTD.
