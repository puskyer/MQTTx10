#!/bin/bash
#

source /etc/default/mymqtt

logger -p local6.info -t MQTT "mymqtt started @ `date`"
mosquitto_pub -h $mqtthost -u $mqttuser -P $mqttpass -t stat/x10 -m "mymqtt started"

while IFS=" " read in1 in2 in3 in4 in5 in6 in7 in8
	do
		out2=""
		dev=`echo $in1 | sed 's/^.*\/x10\/\([a-z]*\)\/.*/\1/g'`
		out2="$in2"
		case $dev in
			kitchen|A1)
				x10dev=A1;
				x10name=kitchen;
				shift;;
        		front|A2)
				x10dev=A2;
				x10name=front;
				shift;;
			brpr|A4)
               		        x10dev=A4;
	                        x10name=brpr;
               		        shift;;
			brjr|A5)
               		        x10dev=A5;
	                        x10name=brjr;
               		        shift;;
			bedroom|A6)
               		        x10dev=A6;
	                        x10name=bedroom;
               		        shift;;
			humidex|A7)
               		        x10dev=A7;
	                        x10name=humidex;
               		        shift;;
			livingroom|A9)
               		        x10dev=A9;
	                        x10name=livingroom;
               		        shift;;
			sumplight|A10)
               		        x10dev=A10;
	                        x10name=sumplight;
               		        shift;;
			sump|A11)
               		        x10dev=A11;
	                        x10name=sump;
               		        shift;;
		        --)  shift ; break ;;
       			 *) logger -p local6.info -t MQTT "Internal error!" ; exit 1 ;;
		esac

		out1="stat/x10/$x10name/POWER"

		if [ "$out2" = "$in2" ] ; then
			if [ "$out2" = "On" ] ;
			then
				logger -p local6.info -t MQTT `echo "pl $x10dev $out2" | nc -q 2 localhost 1099`
			elif [ "$out2" = "Off" ]
			then
				logger -p local6.info -t MQTT `echo "pl $x10dev $out2" | nc -q 2 localhost 1099`
			else
				logger -p local6.info -t MQTT "$out2 for $x10dev is not On/Off?"
			fi
		fi
		logger -p local6.info -t MQTT "in1=$in1 , in2=$in2 , dev=$dev , x10name=$x10name , out1=$out1 , x10dev=$x10dev "
		mosquitto_pub -h $mqtthost -u $mqttuser -P $mqttpass -t $out1 -m $out2
	done < <(mosquitto_sub -v  -h $mqtthost -u $mqttuser -P $mqttpass -t cmnd/x10/+/POWER)
