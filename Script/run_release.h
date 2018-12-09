cd ../
while true
do
  ./.build/release/Calatrava
  DATE=`date +%Y-%m-%d_%H:%M:%S`
  echo '['$DATE']Crash detected!' >> Workspace/runtime/crash.log
done
