#!/bin/sh
mkdir /run/knot
chown knot:knot /run/knot
chown knot:knot /var/lib/knot/

if [ ! -d "/var/lib/knot/confdb" ]; then
	if [ -z "$KNOT_ZONE" ]; then
		echo >&2 'You need to specify a KNOT_ZONE'
		exit 1
	fi

	knotd -d

	until knotc status
	do
		echo "Waiting"
	done

	knotc conf-import /etc/knot/knot.conf
	knotc stop
	
	knotd -d -C /var/lib/knot/confdb/

	until knotc status
	do
		echo "Waiting"
	done

	knotc conf-begin
	knotc conf-set "zone[$KNOT_ZONE]"
	knotc conf-diff
	knotc conf-commit

	knotc zone-begin $KNOT_ZONE
	knotc zone-set $KNOT_ZONE @ 3600 SOA ns hostmaster 1 86400 900 691200 3600
	knotc zone-commit $KNOT_ZONE

	knotc stop
fi

exec knotd -C /var/lib/knot/confdb/
