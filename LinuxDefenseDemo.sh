#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi
install_package() {
    local package_name=$1
    if ! rpm -q $package_name &>/dev/null; then
        echo "Installing $package_name..."
        yum -y install $package_name
    fi
}
#forget what this is from -> completed_checks=()
check_completed() {
    local check_name="$1"
    for completed_check in "${completed_checks[@]}"; do
        if [ "$completed_check" == "$check_name" ]; then
            return 0
        fi
    done
    return 1
}
mark_completed() {
    local check_name="$1"
    completed_checks+=("$check_name")
}
cancel_operation() {
    read -p "Press Enter to continue..."
}
highlight() {
    local color_code="$1"
    shift
    echo -e "\e[${color_code}m$@\e[0m"
}
#i severely don't care enough to do better. it is 6am, i will not be doing better.
bool0=false
bool1=false
bool2=false
bool3=false
bool4=false
bool5=false
bool6=false
bool7=false
bool8=false
bool9=false
bool10=false
bool11=false
bool12=false
bool13=false
bool14=false
bool15=false
while true; do
    clear
    echo "$(highlight 32 "Linux Security Script - Menu")"
    echo "---------------------------"
    echo "Options:"
if [ "$bool0" = false ]; then
    echo "$(highlight 33 "A.") Update and Upgrade System (Quick)"
else
        echo "$(highlight 31 "A.") Update and Upgrade System (Quick)"
fi
if [ "$bool1" = false ]; then
    echo "$(highlight 33 "B.") List Currently Active Users (Quick)"
else
        echo "$(highlight 31 "B.") List Currently Active Users (Quick)"
fi
if [ "$bool2" = false ]; then
    echo "$(highlight 33 "C.") List Users with a Login Shell (Quick)"
else
        echo "$(highlight 31 "C.") List Users with a Login Shell (Quick)"
fi
if [ "$bool3" = false ]; then
    echo "$(highlight 33 "D.") List Potentially Dangerous Network-Connected Processes (Quick)"
else
        echo "$(highlight 31 "D.") List Potentially Dangerous Network-Connected Processes (Quick)"
fi
if [ "$bool4" = false ]; then
    echo "$(highlight 33 "E.") Check for Rootkit Presence (Medium)"
else
        echo "$(highlight 31 "E.") Check for Rootkit Presence (Medium)"
fi
if [ "$bool5" = false ]; then
    echo "$(highlight 33 "F.") Check for Unusual Listening Ports (Medium)"
else
        echo "$(highlight 31 "F.") Check for Unusual Listening Ports (Medium)"
fi
if [ "$bool6" = false ]; then
    echo "$(highlight 33 "G.") Check for Suspicious Processes (Medium)"
else
        echo "$(highlight 31 "G.") Check for Suspicious Processes (Medium)"
fi
if [ "$bool7" = false ]; then
    echo "$(highlight 33 "H.") Check for Unauthorized Sudo Access (Medium)"
else
        echo "$(highlight 31 "H.") Check for Unauthorized Sudo Access (Medium)"
fi
if [ "$bool8" = false ]; then
    echo "$(highlight 33 "I.") Check for Open SSH Sessions (Medium)"
else
        echo "$(highlight 31 "I.") Check for Open SSH Sessions (Medium)"
fi
if [ "$bool9" = false ]; then
    echo "$(highlight 33 "J.") Check for Failed Login Attempts (Medium)"
else
        echo "$(highlight 31 "J.") Check for Failed Login Attempts (Medium)"
fi
if [ "$bool10" = false ]; then
    echo "$(highlight 33 "K.") Check for Excessive Resource Usage (Medium)"
else
        echo "$(highlight 31 "K.") Check for Excessive Resource Usage (Medium)"
fi
if [ "$bool11" = false ]; then
    echo "$(highlight 33 "L.") Check for Unauthorized SUID/SGID Files (Medium)"
else
        echo "$(highlight 31 "L.") Check for Unauthorized SUID/SGID Files (Medium)"
fi
if [ "$bool12" = false ]; then
    echo "$(highlight 33 "M.") Check for Uncommon or Unsafe Permissions (Medium)"
else
        echo "$(highlight 31 "M.") Check for Uncommon or Unsafe Permissions (Medium)"
fi
if [ "$bool13" = false ]; then
    echo "$(highlight 33 "N.") Check for Firewall Rules (Medium)"
else
        echo "$(highlight 31 "N.") Check for Firewall Rules (Medium)"
fi
if [ "$bool14" = false ]; then
    echo "$(highlight 33 "O.") Check for Password Policy Compliance (Quick)"
else
        echo "$(highlight 31 "O.") Check for Password Policy Compliance (Quick)"
fi
if [ "$bool15" = false ]; then
    echo "$(highlight 33 "P.") List Unused User Accounts (Quick)"
else
        echo "$(highlight 31 "P.") List Unused User Accounts (Quick)"
fi
    echo "$(highlight 33 "Q.") Quit"
    read -p "Enter the letter corresponding to the check you want to perform (A-Q): " choice
    case "$choice" in
        [Aa])
            if ! check_completed "Update and Upgrade System"; then
                echo "Updating and upgrading the system..."
                yum -y update
                yum -y upgrade
                mark_completed "Update and Upgrade System"
            else
                echo "Update and Upgrade System has already been completed."
            fi
                bool0=true
            cancel_operation
            ;;
        [Bb])
            echo "Currently active users:"
            who
                bool1=true
            cancel_operation
            ;;
        [Cc])
            echo "Users with a login shell:"
            awk -F: '{ if ($7 != "/sbin/nologin" && $7 != "/bin/false") print $1 }' /etc/passwd
                bool2=true
            cancel_operation
            ;;
        [Dd])
            echo "Potentially dangerous network-connected processes:"
            netstat -tuln | grep -E '(LISTEN|ESTABLISHED)'
                bool3=true
            cancel_operation
            ;;
        [Ee])
            if ! check_completed "Check for Rootkit Presence"; then
                install_package rkhunter
                echo "Checking for rootkits..."
                rkhunter --check --skip-keypress
                mark_completed "Check for Rootkit Presence"
            else
                echo "Check for Rootkit Presence has already been completed."
            fi
                bool4=true
            cancel_operation
            ;;
        [Ff])
            echo "Unusual listening ports:"
            netstat -tuln | awk '$4 !~ /^(127\.0\.0\.1|::1)/ && $6 != "LISTEN"'
                bool5=true
            cancel_operation
            ;;
        [Gg])
            echo "Suspicious processes:"
            ps aux --sort=-%cpu,%mem | awk '$3 > 80 || $4 > 80'
                bool6=true
            cancel_operation
            ;;
        [Hh])
            echo "Unauthorized sudo access:"
            grep -v -E '^#|^$' /etc/sudoers | grep -v -E 'ALL=(ALL:ALL|root)' | grep -E 'ALL|NOPASSWD'
                bool7=true
            cancel_operation
            ;;
        [Ii])
            echo "Open SSH sessions:"
            w
                bool8=true
            cancel_operation
            ;;
        [Jj])
            echo "Failed login attempts:"
            grep "Failed password" /var/log/secure | awk '{print $1,$2,$9}'
                bool9=true
            cancel_operation
            ;;
        [Kk])
            echo "Excessive resource usage:"
            CPU_THRESHOLD=90
            MEMORY_THRESHOLD=90
            ps aux --sort=-%cpu,%mem | awk -v cpu_thresh="$CPU_THRESHOLD" -v mem_thresh="$MEMORY_THRESHOLD" '$3 > cpu_thresh || $4 > mem_thresh'
                bool10=true
            cancel_operation
            ;;
        [Ll])
            echo "Unauthorized SUID/SGID files:"
            find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \;
                bool11=true
            cancel_operation
            ;;
        [Mm])
            echo "Files and directories with unsafe permissions:"
            find / -type f -perm -o+w -exec ls -l {} \;
            find / -type d -perm -o+w -exec ls -ld {} \;
                bool12=true
            cancel_operation
            ;;
        [Nn])
            echo "Firewall rules:"
            iptables -L -n
                bool13=true
            cancel_operation
            ;;
        [Oo])
            echo "Password policy compliance:"
            egrep 'PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE' /etc/login.defs
                bool14=true
            cancel_operation
            ;;
        [Pp])
            echo "Unused user accounts:"
            awk -F: '$7 == "" || $7 == "/bin/false" {print $1}' /etc/passwd
                bool15=true
            cancel_operation
            ;;
        [Qq])
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option (A-Q)."
            cancel_operation
            ;;
    esac
done
