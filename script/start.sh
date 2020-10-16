HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-ipv4n/)
export RELEASE_NODE=cluster_test@${HOSTNAME}

bin/cluster_test start
