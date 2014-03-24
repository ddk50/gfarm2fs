#!/bin/sh

#
# $Id: gfarm2fs_fix_acl.sh 5239 2011-03-29 12:01:01Z takuya-i $
#

gfgroup_exist() {
  group=$1
  user=$2

  gfgroup -l $group | egrep " ${user} | ${user}\$" > /dev/null
  return $?
}

WHOAMI=`gfwhoami`
if gfgroup_exist gfarmroot $WHOAMI ; then
  :
else
  echo You\(${WHOAMI}\) do not belong to gfarmroot. 1>&2
  exit 1
fi

TMP=`mktemp -d`
if [ $? -ne 0 ]; then
  echo cannot create a temporary directory. 1>&2
  exit 1
fi

gfarm2fs $TMP -o fix_acl
wait

find $TMP -exec gfarm2fs_fix_acl -cr {} \;
retv=$?

sleep 10
fusermount -u $TMP
rmdir $TMP

exit $retv
