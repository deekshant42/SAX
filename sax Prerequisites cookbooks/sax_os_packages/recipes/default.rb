package "epel-release" do
	action :install
end

package "sshpass" do

	action :install
end

#To install SSH
package "openssh-server" do
        action :install
end

#To verify and install the wget
package "wget" do
        action :install
end


#To verify and install the tar
package "tar" do
        action :install
end

#To verify and install the zip
package "zip" do
        action :install
end

#TO verify and install the Yum
package "yum" do
        action :install
end

#To Verify and install the nmap
package "nmap" do
        action :install
end

#TO verify and install the Unzip
package "unzip" do
        action :install
end


#To install and run NTP/NTPD
package 'ntp' do
    action :install
end


service 'ntpd' do
   action [:enable, :start]
end
