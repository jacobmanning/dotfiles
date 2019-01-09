ls ~

if [ $(id -u) = "0" ]; then
  echo 'Running as root'
else
  echo 'NOT running as root'
fi
