#!/bin/bash

BASEPATH=/opt/infrastructure;
BINPATH=/usr/local/bin

case "$1" in
  "download")
    $BASEPATH/sync.sh download;
    exit $?;
  ;;

  "generate")
    node $BASEPATH/index.js;
    exit $?;
  ;;

  "remove")
    if [ -L "/usr/local/bin/infrastructure" ]; then
      LINK_INFRASTRUCTURE=$BINPATH/infrastructure;
      echo "Removing $LINK_INFRASTRUCTURE"
      rm $LINK_INFRASTRUCTURE;
    fi
    exit 0;
  ;;

  "setup")
    $BASEPATH/setup.sh;
    exit $?;
  ;;

  "upload")
    $BASEPATH/sync.sh upload;
    exit $?;
  ;;

  *)
    echo "                                                                        ";
    echo "  .__          _____                                                    ";
    echo "  |__|  ____ _/ ____\_______ _____                                      ";
    echo "  |  | /    \\   __\ \_  __ \\__  \                                     ";
    echo "  |  ||   |  \|  |    |  | \/ / __ \_                                   ";
    echo "  |__||___|  /|__|    |__|   (____  /                                   ";
    echo "           \/                     \/                                    ";
    echo "            __                           __                             ";
    echo "    _______/  |_ _______  __ __   ____ _/  |_  __ __ _______   ____     ";
    echo "   /  ___/\   __\\_  __ \|  |  \_/ ___\\   __\|  |  \\_  __ \_/ __ \    ";
    echo "   \___ \  |  |   |  | \/|  |  /\  \___ |  |  |  |  / |  | \/\  ___/    ";
    echo "  /____  > |__|   |__|   |____/  \___  >|__|  |____/  |__|    \___  >   ";
    echo "       \/                            \/                           \/    ";
    echo "                                                                        ";
    echo "------------------------------------------------------------------------";
    echo "  Infrastructure - https://github.com/nativecode-dev/infrastructure     ";
    echo "  See the license in the repository.                                    ";
    echo "  © 2016 NativeCode Development.                                        ";
    echo "------------------------------------------------------------------------";
    echo "  ASCII Art generated with http://bit.ly/1RoZOBn                        ";
    echo "------------------------------------------------------------------------";
    echo "                                                                        ";
    echo "  # infrastructure [command]                                            ";
    echo "                                                                        ";
    echo "    Commands                                                            ";
    echo "                                                                        ";
    echo "    download      - Downloads composer files from a dropbox location.   ";
    echo "    generate      - Generates docker-compose.yml files.                 ";
    echo "    remove        - Removes installed symlinks.                         ";
    echo "    setup         - Configures the machine as a deployment target.      ";
    echo "    upload        - Uploads composer files to a dropbox location.       ";
    echo "                                                                        ";
    echo "    Opinionated locations:                                              ";
    echo "                                                                        ";
    echo "    /etc/infrastructure         - location of composer files.           ";
    echo "    /etc/infrastructure/<name>  - location of generated composer files. ";
    echo "    /opt/infrastructure         - location of local git repository.     ";
    echo "    /usr/share/<name>           - location of composer volumes.         ";
    echo "                                                                        ";
    echo "                                                                        ";
    echo "  BASE    : $BASEPATH                                                   ";
    echo "  BIN     : $BINPATH                                                    ";
  ;;
esac
