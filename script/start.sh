HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
export RELEASE_NODE=cluster_test@${HOSTNAME}

/cluster_test/bin/cluster_test start
