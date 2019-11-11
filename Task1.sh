    #!/bin/bash

    #### Khawaja Abdul Hafeez - Task 1 ####

    # Log files with timestamp for each time the script is run.
    Logfile="logfile.txt"    #Logfile name and extension
    MAIL_LOG="Server Monitoring Script called at: $(date) by user $(whoami)"  #Message to print/append in the log file
    Location="./"    ##Path to store the log files. Default is the same directory in which the script is present.

    cd $Location   
    if [ -f $Logfile ]  
    then   
    echo "$MAIL_LOG " >> $Logfile

    else        

    touch $Logfile   
    echo "$MAIL_LOG" >> $Logfile    

    fi 

    ##
    ## The Server Monitor
    ##
    echo "Server Monitoring Menu"

    PS3='Please select what task would you like to perform [for e.g. 1]...' 

    ## Options for select menu:
    options=(
    "Total RAM available" 
    "Total storage space available for a mount point" 
    "List top 5 processes for a specific user" 
    "List the ports exposed and the process associate with it"
    "Option to free up cached memory"
    "For a given directory list the files with their size in (MBs), and sort them with descending order"
    "For a given directory, list the Folders with their size in (MBs), and sort them with descending order")


    select opt in "${options[@]}"
    do
        case $opt in
            "Total RAM available") #1
                echo "Total RAM stats"
                free #free -m command displays the total amount of free space available along with the amount of memory used in MBs 
                break
                ;;
            "Total storage space available for a mount point") #2
                df -h #df: Disk Free command. -h: human readable format
                break
                ;;
            "List top 5 processes for a specific user") #3
                echo "Enter username... "
                read username
                ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | grep $username | head -n 6
                #ps -Ao user,uid,comm,pid,pcpu,tty -r | grep devops | head -n 6 ## FOR CentOS
                ##For Linux
                break
                ;;
            "List the ports exposed and the process associate with it") #4
                netstat -plntu # p: process, l: listening ports, n: network, t: TCP, u: UDP
                break
                ;;
            "Option to free up cached memory") #5
                echo "Clearing Memory Cached...\n"
                sudo sh -c "/usr/bin/echo 3 > /proc/sys/vm/drop_caches" # “...echo 1 >...” will clear the PageCache.
                echo "Done"
                free #Show the available memory to show memory difference after cache being cleared.
                break
                ;;
            "For a given directory list the files with their size in (MBs), and sort them with descending order") #6
                echo "Please enter the path to the directory: "
                read files_directory
                echo "You selected " $files_directory
                eval cd $files_directory # eval takes a string as its argument, and evaluates it as if you'd typed that string on a command line. 
                ls -plhS --block-size=M | egrep -v /$ # ls -lhS: sort by size, in human readable format
                break
                ;;
            "For a given directory, list the Folders with their size in (MBs), and sort them with descending order") #7
                echo "Please enter the path to the directory: "
                read folder_directory
                echo "Entered path to the directory " $folder_directory
                eval cd $folder_directory # eval takes a string as its argument, and evaluates it as if you'd typed that string on a command line. 
                ls -lS --block-size=M | grep '^d'
                #ls -shSd */ # ls -l: long-desc, s: show size, h: human-readable, S: sort by size, -d */: directories only
                break
                ;;
            *) echo "invalid option $REPLY";; #Validation to avoid failures 
        esac
    done