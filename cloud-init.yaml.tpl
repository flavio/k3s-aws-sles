#cloud-config

# set locale
locale: en_US.UTF-8

# set timezone
timezone: Etc/UTC

ssh_authorized_keys:
${authorized_keys}

bootcmd:
  - ip link set dev eth0 mtu 1500

runcmd:
  - echo "solver.onlyRequires = true" >> /etc/zypp/zypp.conf

final_message: "The system is finally up, after $UPTIME seconds"

