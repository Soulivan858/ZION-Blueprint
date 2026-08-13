#!/bin/bash

WALLET_FILE="$HOME/.zion_wallet_data"
LOG_FILE="$HOME/.zion_wallet_log"
PIN_FILE="$HOME/.zion_wallet_pin"

# Initialize Wallet if not exists
if [ ! -f "$WALLET_FILE" ]; then
    echo "BALANCE=1000" > "$WALLET_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Wallet initialized" > "$LOG_FILE"
fi

# Function to verify PIN
verify_pin() {
    if [ ! -f "$PIN_FILE" ]; then
        echo -e "\n🔒 ตั้งค่า PIN สำหรับกระเป๋าเงิน (6 หลัก):"
        read -s -p "ตั้งรหัส PIN: " new_pin
        echo "$new_pin" > "$PIN_FILE"
        echo -e "\n✅ ตั้งค่า PIN สำเร็จ!"
        return 0
    fi

    echo -e "\n🔐 โปรดระบุรหัส PIN เพื่อดำเนินการ:"
    read -s -p "ใส่รหัส PIN: " input_pin
    stored_pin=$(cat "$PIN_FILE")
    
    if [ "$input_pin" == "$stored_pin" ]; then
        echo -e "\n✅ ยืนยันตัวตนสำเร็จ!"
        return 0
    else
        echo -e "\n❌ รหัส PIN ไม่ถูกต้อง! ยกเลิกรายการ"
        return 1
    fi
}

source "$WALLET_FILE"

show_menu() {
    echo -e "\n================================="
    echo "       💎 ZION WALLET CLI 💎     "
    echo "================================="
    echo "1. เช็กยอดเงินคงเหลือ"
    echo "2. โอนเงิน (ต้องการ PIN)"
    echo "3. เติมเงิน (ต้องการ PIN)"
    echo "4. ดูประวัติธุรกรรม"
    echo "5. ออกจากโปรแกรม"
    echo "================================="
    read -p "เลือกเมนู [1-5]: " choice
    case $choice in
        1) check_balance ;;
        2) if verify_pin; then transfer_coins; else show_menu; fi ;;
        3) if verify_pin; then topup_coins; else show_menu; fi ;;
        4) view_history ;;
        5) exit 0 ;;
        *) echo "❌ ตัวเลือกไม่ถูกต้อง!"; sleep 1; show_menu ;;
    esac
}

check_balance() {
    echo -e "\n💰 ยอดเงินคงเหลือของคุณ: $BALANCE ZION Coins"
    read -p "กด Enter เพื่อกลับเมนูหลัก..."
    show_menu
}

transfer_coins() {
    echo -e "\n💸 -- โอนเงิน --"
    read -p "ระบุ Username ผู้รับ: " recipient
    read -p "ระบุจำนวน Coin: " amount
    
    if [[ "$amount" =~ ^[0-9]+$ ]] && [ "$amount" -gt 0 ] && [ "$amount" -le "$BALANCE" ]; then
        BALANCE=$((BALANCE - amount))
        echo "BALANCE=$BALANCE" > "$WALLET_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Transferred $amount Coins to $recipient" >> "$LOG_FILE"
        echo "✅ โอนสำเร็จ! ยอดคงเหลือใหม่: $BALANCE ZION Coins"
    else
        echo "❌ ยอดเงินไม่พอ หรือระบุจำนวนไม่ถูกต้อง!"
    fi
    read -p "กด Enter เพื่อกลับเมนูหลัก..."
    show_menu
}

topup_coins() {
    echo -e "\n📥 -- เติมเงิน --"
    read -p "ระบุจำนวน Coin ที่ต้องการเติม: " amount
    if [[ "$amount" =~ ^[0-9]+$ ]] && [ "$amount" -gt 0 ]; then
        BALANCE=$((BALANCE + amount))
        echo "BALANCE=$BALANCE" > "$WALLET_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Top-up $amount Coins" >> "$LOG_FILE"
        echo "✅ เติมเงินสำเร็จ! ยอดคงเหลือใหม่: $BALANCE ZION Coins"
    else
        echo "❌ ระบุจำนวนไม่ถูกต้อง!"
    fi
    read -p "กด Enter เพื่อกลับเมนูหลัก..."
    show_menu
}

view_history() {
    echo -e "\n📜 -- ประวัติธุรกรรม --"
    cat "$LOG_FILE"
    read -p "กด Enter เพื่อกลับเมนูหลัก..."
    show_menu
}

chmod +x scripts/check_wallet.sh
show_menu
