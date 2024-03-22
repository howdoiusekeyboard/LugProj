#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
ORANGE='\033[1;33m'
NC='\033[0m' # No Color

# Game variables
score=0
level=1
max_level=10

# Animation functions
loading_animation() {
    echo -ne "${BLUE}"
    for ((i=0; i<20; i++)); do
        for ((j=0; j<$i; j++)); do
            echo -ne "█"
        done
        for ((j=$i; j<20; j++)); do
            echo -ne " "
        done
        sleep 0.1
        echo -ne "\r"
    done
    echo -e "${NC}"
    sleep 2
}

success_animation() {
    for ((i=0; i<3; i++)); do
        echo -e "${GREEN}✓${NC}"
        sleep 0.1
    done
}

failure_animation() {
    for ((i=0; i<3; i++)); do
        echo -e "${RED}✗${NC}"
        sleep 0.1
    done
}

orange_penguin() {
    tput sc
    tput cup $(($(tput lines)-10)) $(($(tput cols)-20))
    echo -e "${ORANGE}
        .--.
       |o_o |
       |:_/ |
      //   \\ \\
     (|     | )
    /'\_   _/\`\\
    \___)=(___/
    ${NC}"
    sleep 3
    tput rc
    tput ed
}

# Game functions
print_header() {
    echo -e "${BLUE}"
    cat << "EOF"
    ███╗   ███╗ █████╗ ██╗     ██╗███╗   ██╗      ██████╗  █████╗ ███╗   ███╗███████╗
    ████╗ ████║██╔══██╗██║     ██║████╗  ██║     ██╔════╝ ██╔══██╗████╗ ████║██╔════╝
    ██╔████╔██║███████║██║     ██║██╔██╗ ██║     ██║  ███╗███████║██╔████╔██║█████╗  
    ██║╚██╔╝██║██╔══██║██║     ██║██║╚██╗██║     ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  
    ██║ ╚═╝ ██║██║  ██║███████╗██║██║ ╚████║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗
    ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
    echo -e "${NC}"
}

print_level() {
    echo -e "${PURPLE}Level: $level${NC}"
}

print_score() {
    echo -e "${GREEN}Score: $score${NC}"
}

print_task() {
    echo -e "${CYAN}$1${NC}"
}

read_command() {
    echo -e "${RED}Enter command:${NC} "
    read command
    echo
}

update_score() {
    score=$((score + 10))
    success_animation
    if [ "$level" -eq "$max_level" ]; then
        echo -e "${GREEN}Congratulations! You've completed all levels and achieved the maximum score of $score!${NC}"
        exit 0
    else
        level=$((level + 1))
        echo -e "${GREEN}Well done! Your score is now $score.${NC}"
    fi
}

game_loop() {
    print_header
    while [ "$level" -le "$max_level" ]; do
        print_level
        print_score

        # Randomly display the orange penguin (increased probability)
        if [ $((RANDOM % 10)) -lt 4 ]; then
            orange_penguin
        fi

        case "$level" in
            1)
                print_task "Task: Change to the 'games' directory."
                read_command
                if [[ "$command" == "cd games" ]]; then
                    update_score
                else
                    failure_animation
                    echo -e "${RED}Oops, that's not correct. Try again!${NC}"
                fi
                ;;
            2)
                print_task "Task: Extract the 'mystery.tar.gz' file."
                read_command
                if [[ "$command" == "tar -xzf mystery.tar.gz" ]]; then
                    update_score
                else
                    failure_animation
                    echo -e "${RED}Oops, that's not correct. Try again!${NC}"
                fi
                ;;
            3)
                print_task "Task: Run the 'mystery.sh' script."
                read_command
                if [[ "$command" == "bash mystery.sh" ]]; then
                    update_score
                    echo -e "${GREEN}Congratulations! You've solved all the tasks.${NC}"
                    echo -e "${GREEN}The Password is the mascot of linux!!: .${NC}"
                    echo -e "${PURPLE}Enter the password to win the game:${NC}"
                    read password
                    if [[ "$password" == "tux" ]]; then
                        echo -e "${GREEN}You did it! You've won the Linux Adventure Game!${NC}"
                        cmatrix
                    else
                        echo -e "${RED}Sorry, that's not the correct password. Better luck next time!${NC}"
                    fi
                    exit 0
                else
                    failure_animation
                    echo -e "${RED}Oops, that's not correct. Try again!${NC}"
                fi
                ;;
        esac
    done
}

# Start the game
loading_animation
game_loop
