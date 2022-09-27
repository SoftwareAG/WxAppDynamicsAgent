export TARGET="https://localhost:9000/argento"
export TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`
export OUTPUT="argento-diagnostics-$TIMESTAMP.log"
curl -s -k -u admin:admin "$TARGET?vitals&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?runtime&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?threads&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?instrumentation&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?properties&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?learnedevents&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?network&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?memory&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?modules&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?assessmentstats&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?heartbeatstats&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?networkstats&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?agenthreads&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?authservice&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?securitymanager&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?servletstats&diagcommand" >> $OUTPUT
curl -s -k -u admin:admin "$TARGET?headerstats&diagcommand" >> $OUTPUT