#!/bin/sh
#每天打卡实在麻烦. 老板还检查. 

key="server酱的key"
deviceID="-s 设备ID"

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

function sendMsg(){
	curl -s "http://sc.ftqq.com/$key.send?text=\"$1\"" -d "&desp=\"$2\""
}

function isScreenOn(){
	screenState=`adb shell dumpsys window policy|grep mScreenOnFully`	
	result=$(echo $screenState | grep "${mScreenOnFully=false}")
	#echo $result

	if [[ "$result" != "" ]]
	then
     	#echo "屏幕关"
     	return 1

	else
    	 #echo "屏幕开"
    	 return 0
	fi	
}

#判断设备有没有连接
deviceList=($(adb devices |grep "device"|grep -v "List" ))
echo $deviceList
if [[ -z $deviceList ]];
	then
    echo "设备没有连接"
    sendMsg "设备没有连接"
    exit 0
else
    echo "设备已经连接"$deviceList
fi


#随机时间打卡
rnd=$(rand 1 20)
echo "sleep "$[rnd]" min"

sendMsg "$[rnd]分钟后开始打卡"

#exit 0

sleep $[rnd*60]


if isScreenOn; 
	then 
		echo "screen on "; 
		#判断是否锁屏, 如果锁屏,就滑动开
		adb ${devicesID} shell input swipe 455 1638 648 -189
		sleep 1s
		adb ${devicesID} shell input keyevent 3
		sleep 1s
	else 
		echo "screen off"; 
		adb ${devicesID} shell input keyevent 26
		sleep 1s
		adb ${devicesID} shell input swipe 455 1638 648 -189
		sleep 1s
fi


echo "start daka"

adb shell monkey -p com.tencent.wework -c android.intent.category.LAUNCHER 1
sleep 10s
adb ${devicesID} shell input tap 676 1801
sleep 1s
adb ${devicesID} shell input tap 550 1334
sleep 5s
#repeat
adb ${devicesID} shell input keyevent 4
sleep 1s

adb ${devicesID} shell input tap 550 1334
sleep 5s
adb ${devicesID} shell input tap 550 1334
sleep 1s
adb ${devicesID} shell input keyevent 4
sleep 1s
adb ${devicesID} shell input keyevent 4
sleep 1s
adb ${devicesID} shell input keyevent 4
sleep 1s
adb ${devicesID} shell input keyevent 3
sleep 1s
adb ${devicesID} shell input keyevent 26
#
echo "daka shell done!"

sendMsg "打卡完成"

exit 0
