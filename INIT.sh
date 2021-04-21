#!/bin/sh
if ! hash java 2>/dev/null; then
    sudo apt install default-jdk -y && sudo apt upgrade && sudo apt clean
fi
if ! hash git 2>/dev/null; then
    sudo apt install git -y && sudo apt upgrade && sudo apt clean
fi
if ! hash screen 2>/dev/null; then
    sudo apt install screen -y && sudo apt upgrade && sudo apt clean
fi
if [ ! -d "work" ]; then
    curl -v -o ~/BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
git config --global --unset core.autocrlf
java -jar ~/BuildTools.jar
cat > ~/eula.txt <<- EOM
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Wed Apr 21 16:26:05 UTC 2021
eula=true
EOM
fi
if [ -f "eula.txt" ]; then
    LC_ALL="en_US.UTF-8" perl -pi -e 's/false/true/g' eula.txt
fi
touch ~/default_start.sh
cat > ~/default_start.sh <<- EOM
#!/bin/sh
screen -AmdS Minecraft java -Xms2G -Xmx6G -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=10 -jar spigot-*.jar
EOM
chmod +x ~/default_start.sh
~/default_start.sh
