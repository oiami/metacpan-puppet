#!/bin/sh

find /etc/puppet -type d -exec chmod a+rx {} \;
find /etc/puppet -type f -exec chmod a+r {} \;

cd /etc/puppet

# Aways specify the cername so we get the right config
# the arg should really exist in the autosign.conf if possible
CERTNAME=$1
if [ ! $CERTNAME ]
then
    CERTNAME=$(hostname -s)
    echo "Assuming node $CERTNAME"
    echo "Supply a node arg to override"
fi

# Just create a basic conf to set parser=future
if [ ! -e "puppet.conf" ]
  then
    echo "[main]" >> puppet.conf
    echo "parser=future" >> puppet.conf
fi

if grep -Fq "parser=future" puppet.conf
then
    echo "parser=future enabled, carry on..."
else
    echo "You need to add 'parser=future' to the puppet.conf"
    exit
fi

puppet apply --verbose --show_diff --certname=$CERTNAME manifests/site.pp
