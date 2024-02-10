saves="/home/wyatt/.local/share/multimc/instances"

pushd $saves
find . -type d -name "saves" | grep -v "prac" | xargs rm -rf