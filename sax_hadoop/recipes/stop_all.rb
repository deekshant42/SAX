bash 'stop hadoop services' do
  user node['sax_hadoop']['owner']
  cwd "#{node['sax_hadoop']['hadoop_untar']}/etc/hadoop"
  code <<-EOH
    sshpass -p sax ssh -o StrictHostKeyChecking=no #{node['sax_hadoop']['username_to_ssh']}@#{node['sax_hadoop']['master_IP_addr']} "cd #{node['sax_hadoop']['hadoop_untar']}/sbin;stop-all.sh"
    EOH
end



