##set title funring API
#echo "**********Phai co jdk 7+"
#echo "**********log file trong logs/console.log.date"
#exec /usr/jdk/instances/jdk1.7.0/bin/java -Dfile.encoding=UTF-8 -Doracle.jdbc.defaultNChar=true -classpath "lib/neo-server-1.0.jar:lib/*" -Dlog4j.configuration=file:conf/log4j.properties -Dlog4j.debug neo.server.Run
if [ "$1" = "start" ] ; then
    shift
	exec /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.65.x86_64/jre/bin/java -Dfile.encoding=UTF-8 -Doracle.jdbc.defaultNChar=true -classpath "neo_rating.jar:lib/*" -Dlog4j.configuration=file:conf/log4j.properties -Dlog4j.debug net.schedule.AutoCall >logs/server.log 2>&1 &
	if ps aux | grep -q "[n]et.schedule.AutoCall"; then
		echo "RUNNING"
	else
		echo "ERROR"
	fi
	echo $! > api.pid
elif [ "$1" = "stop" ] ; then
    echo "STOPPED"
    shift
    kill -9 `cat api.pid`
	kill -9 `cat pid1.pid`
    rm -rf api.pid
	rm -rf pid1.pid
else
    echo "Usage:"
    echo "service (start|stop)"
    exit 0
fi
