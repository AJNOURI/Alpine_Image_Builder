#/bin/bash

function header(){
  echo "FROM alpine" > Dockerfile
  echo "RUN apk update" >> Dockerfile
  echo "RUN apk add openssh" >> Dockerfile
}

function footer(){
  echo "VOLUME /root/.ssh /etc/ssh /data" >> Dockerfile
  echo "ADD start-ssh.sh start-ssh.sh" >> Dockerfile
}

function addtool(){
  echo "RUN apk add $1" >> Dockerfile
}

cmd=(dialog --separate-output --checklist "Select tools to include in the Docker image:" 22 76 16)
options=(mtr "Combines 'traceroute' and 'ping' in a single network diagnostic tool." off
         nmap "For network discovery and security auditing" off
         iperf "Tool for active Bandwidth measurements." off
         socat "Relay for bidirectional data transfer under Linux." off
         vim "Text editor" off
         nano "Text editor" off
         curl "Get documents/files from or send documents to a server." off
         links "Text web browser." off
         iputils "Set of small useful utilities for Linux networking." off
         bind-tools "DNS tools including dig." off
         rsync "Provides fast incremental file transfer." off
         bash "sh-compatible shell that incorporates useful features." off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

response=$?
case $response in
   0) ;;
   1) clear;exit 0;;
   255) clear;exit 0;;
esac

header
for choice in $choices
do
    case $choice in
        mtr)
            addtool mtr;;
        nmap)
            addtool nmap;;
        iperf)
            addtool iperf;;
        socat)
            addtool socat;;
        vim)
            addtool vim;;
        nano)
            addtool nano;;
        curl)
            addtool curl;;
        links)
            addtool links;;
        iputils)
            addtool iputils;;
        bind-tools)
            addtool bind-tools;;
        rsync)
            addtool rsync;;
        bash)
            addtool bash;;
    esac
done
footer

while true
do
  dialog --title "Docker image name" --inputbox "Give a name to your image:" 8 40 2> inputbox.tmp.$$ 
  image=`cat inputbox.tmp.$$`
  echo $image
  if [[ -z "${image// /}" ]]; then
    dialog --title "Required" --msgbox 'Image name cannot be empty!' 10 40
  else
    break
  fi 
done

docker build -t $image .

rm -f inputbox.tmp.$$
#clear
