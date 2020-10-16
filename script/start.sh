HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-ipv4 | sed "s/\./-/g")
export RELEASE_NODE=cluster_test@ip-${HOSTNAME}

/cluster_test/bin/cluster_test start
