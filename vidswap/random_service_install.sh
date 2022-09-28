 #!/bin/bash

sed -e "s|WORKDIR|$( pwd )|" -e "s|SCRIPTDIR|$( pwd )/randomizer.sh|" randomvid.service_template > randomvid.service
systemctl --user enable --now "$( pwd )/randomvid.service"
