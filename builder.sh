#/bin/bash

function header(){
  echo "FROM alpine" > Dockerfile
  echo "RUN apk update" >> Dockerfile
}

function addtool(){
  echo "RUN apk add $1" >> Dockerfile
}

cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "openssh" off
         2 "mtr" off
         3 "nmap" off
         4 "iperf" off
         5 "socat" off
         6 "vim" off
         7 "nano" off
         8 "curl" off
         9 "links" off
         10 "iputils" off
         11 "rsync" off
         12 "bash" off)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

response=$?
case $response in
   0) ;;
   1) exit 0;;
   255) exit 0;;
esac

header
for choice in $choices
do
    case $choice in
        1)
            addtool openssh
            ;;
        2)
            addtool mtr
            ;;
        3)
            addtool nmap
            ;;
        4)
            addtool iperf
            ;;
        5)
            addtool socat
            ;;
        6)
            addtool vim
            ;;
        7)
            addtool nano
            ;;
        8)
            addtool curl
            ;;
        9)
            addtool links
            ;;
        10)
            addtool iputils
            ;;
        11)
            addtool rsync
            ;;
        12)
            addtool bash
            ;;
    esac
done


while true
do
  dialog --title "Docker image name" --inputbox "Give a name to your image:" 8 40 2> inputbox.tmp.$$ 
  image=`cat inputbox.tmp.$$`
  echo $image
  if [[ -z "${image// /}" ]]; then
    dialog --title "Required" --msgbox 'Image name cannot be empty!' 6 20
  else
    break
  fi 
done

docker build -t $image .

rm -f inputbox.tmp.$$
#clear
