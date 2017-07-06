#!/bin/bash

echo -e "\033[0;36m   _____                          _____ \033[0mVersion 1.0 by HimbeersaftLP \033[0;36m"
echo "  / ____|                        / ____|              | |            "
echo " | (___  _ __   ___   ___  _ __ | |     _ __ ___  __ _| |_ ___  _ __ "
echo "  \___ \| '_ \ / _ \ / _ \| '_ \| |    | '__/ _ \/ _\` | __/ _ \| '__|"
echo "  ____) | |_) | (_) | (_) | | | | |____| | |  __/ (_| | || (_) | |   "
echo " |_____/| .__/ \___/ \___/|_| |_|\_____|_|  \___|\__,_|\__\___/|_|   "
echo -e "        | |       \033[0mhttps://github.com/HimbeersaftLP/SpoonCreator      \033[0;36m"
echo -e '        |_| \033[0mAdd spoon features to PMMP to create your "unique" spoon!'

RED='\033[0;31m'
NF='\033[0m'

psucc(){
    if [ $? -eq 0 ]; then
        echo -e "\n\033[0;34m***********************\n* Operation complete! *\n***********************\033[0m"
        SUCC=yes
    else
        echo -e "\n${RED}*********************\n* Operation failed! *\n*********************\033[0m"
        SUCC=no
    fi
}

while true
    do
        echo ""
        echo -e '\033[0;32m***** Avaiable Options: *****'${NF}
        echo 'a) Clone PocketMine (you will need to do this unless you already have a folder called PocketMine-MP with the same file structure as the GitHub version in the same directory this script is running in)'
        echo 'b) Enable loading plugins with all APIs using the "compatible=true" hack.'
        echo 'c) Enable MCPE 1.1 lighting bug fixer (see https://forums.pmmp.io/posts/26920), this will edit the default pocketmine.yml too!'
        echo 'd) Build phar'
        echo 'e) Delete the PocketMine-MP folder from this directory (use this to prevent errors when cloning again)'
        echo 'f) Clone PocketMine DevTools (you will need to do this to build the phar file)'
        echo 'g) Download PHP7 (you will need to do this to build the phar file)'
        echo 'x) Exit Script'
        if [ "$SUCC" == "yes" ]
          then
            echo -e "\033[0;34mThe last Operation (${LOP}) was completed successfully!${NF}"
          elif [ "$SUCC" == "no" ]
            then
              echo -e "${RED}The last Operation (${LOP}) was was not successfull!"
              echo -e "Reason: ${NF}${EROP}"
        fi

        read -p "Enter a letter to execute a function: " selection
        case "$selection" in
            a|A) echo "Cloning PocketMine-MP from https://github.com/pmmp/PocketMine-MP..."
                 EROP=$(git clone --recursive "https://github.com/pmmp/PocketMine-MP.git" 2>&1)
                 psucc
                ;;
            b|B) echo "Editing PluginManager.php..."
                 EROP=$(sed -i 's/compatible = false;/compatible = true;/g' PocketMine-MP/src/pocketmine/plugin/PluginManager.php 2>&1)
                 psucc
                ;;
            c|C) echo "Editing Level.php..."
                 EROP=$(sed -i 's/!$chunk->isLightPopulated() and //g' PocketMine-MP/src/pocketmine/level/Level.php 2>&1)
                 echo "Editing pocketmine.yml..."
                 EROP+="\n"$(sed -i 's/light-updates: false/light-updates: true/g' PocketMine-MP/src/pocketmine/resources/pocketmine.yml 2>&1)
                 psucc
                ;;
            d|D) echo -e "Building DevTools and PocketMine Phar"
                 bin/php7/bin/php PocketMine-DevTools/src/DevTools/ConsoleScript.php --make PocketMine-DevTools --relative PocketMine-DevTools --out PocketMine-MP/plugins/DevTools.phar
                 cd PocketMine-MP
                 EROP=$(echo -e "version\nmakeserver\nstop\n" | ../bin/php7/bin/php src/pocketmine/PocketMine.php --no-wizard --disable-ansi --disable-readline --debug.level=2)
                 cd ..
                 if ls PocketMine-MP/plugins/DevTools/PocketMine*.phar >/dev/null 2>&1; then
                     echo "Server phar created successfully."
                     cp PocketMine-MP/plugins/DevTools/PocketMine*.phar pocketmine.phar
                     echo "Your new phar is now called pocketmine.phar!"
                 else
                     echo "${RED}No phar created!"
                 fi
                 psucc
                ;;
            e|E) echo "Deleting PocketMine-MP folder..."
                 rm -rf PocketMine-MP/
                 psucc
                ;;
            f|F) echo "Cloning PocketMine-DevTools from https://github.com/pmmp/PocketMine-DevTools.git..."
                 EROP=$(git clone --recursive "https://github.com/pmmp/PocketMine-DevTools.git" 2>&1)
                 psucc
                ;;
            g|G) echo "Download PHP7 from https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.3_x86-64_Linux.tar.gz..."
                 EROP=$(wget https://bintray.com/pocketmine/PocketMine/download_file?file_path=PHP_7.0.3_x86-64_Linux.tar.gz)
                 tar -xzf download_file?file_path=*
                 rm download_file?file_path=*
                 psucc
                ;;
            x|X) echo -e "${RED}Bye, bye!${NF}"
                 exit 0
                ;;
            *) echo -e "${RED}*********************\n* Unknown function! *\n*********************${NF}"
               EROP="Unknown Function"
               SUCC=no
                ;;
        esac
        LOP=$selection
done
