#!/bin/sh
blocks=`/getglocks`
if [ -z "${blocks}" ];then
	echo "No blocks to used"
	sleep 86400
else
	echo "Found blocks for lvmd ${blocks}"
fi

DEVICE=`echo ${blocks}|tr "," " "`

LVM_CONF=/etc/lvm/lvm.conf
if [ ! -f ${LVM_CONF}.bak ];then
        cp -a ${LVM_CONF} ${LVM_CONF}.bak
fi
sed -i.save -e "s#write_cache_state = 1#write_cache_state = 0#" ${LVM_CONF}
mount --rbind ${MOUNT_PATH} /dev

for l in `lvs ${VG_NAME}|grep -v "Attr"|awk '{print $1}'`;do
        if [ ! -L /dev/${VG_NAME}/$l ];then
                lvremove ${VG_NAME}/$l -f
        fi
done

for i in $DEVICE;do
	pvs |grep -E "$i" -w -q
	if [ $? -ne 0 ];then
		pvcreate $i -y
	else
		echo "Physical volume $i already exists"
	fi
done

vgs |grep -E "${VG_NAME}" -w -q
if [ $? -ne 0 ];then
	vgcreate ${VG_NAME} ${DEVICE} -y
else
	echo "Volume group ${VG_NAME} already exists"
fi

netstat -nutlp  | grep 1736 | grep lvmd
if [ $? -eq 0 ];then
	kill -9 `netstat -nutlp  | grep 1736 | grep lvmd|awk -F " |/"  '{print $(NF-1)}'`
	sleep 1
	kill -9 `netstat -nutlp  | grep 1736 | grep lvmd|awk -F " |/"  '{print $(NF-1)}'`
	sleep 1
	kill -9 `netstat -nutlp  | grep 1736 | grep lvmd|awk -F " |/"  '{print $(NF-1)}'`
fi
/lvmd -v 5 -listen 0.0.0.0:1736 -logtostderr
