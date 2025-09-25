!#/bin/bash

touch /root/post-run.log

# Creating ansible config on host
echo "Creating site.yml" >> /root/post-run.log
tee -a ~/site.yml << EOF
---
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_version: 2022
    mssql_ip_address: 0.0.0.0
    mssql_enable_sql_agent: true
    mssql_install_fts: true
    mssql_install_powershell: true
    mssql_tune_for_fua_storage: true
    firewall:
      port: ['1433/tcp']
      state: enabled

  roles:
    - microsoft.sql.server
    - redhat.rhel_system_roles.firewall

EOF

tee -a ~/ansible.cfg << EOF
[defaults]
host_key_checking=False
[ssh_connection]
ssh_args=
EOF


echo "Setting hostname env" >> /root/post-run.log
export HOSTNAME=`hostname --all-fqdns` &>> /root/post-run.log

echo "Setting hostname as localhost in site.yml"
sed -i -e "s/host1/localhost/g" site.yml &>> /root/post-run.log
#sed -i -e "s/host1/$HOSTNAME/g" site.yml &>> /root/post-run.log

echo "Installing ansible-core" >> /root/post-run.log
dnf -y install ansible-core