#!/bin/bash

# ZION Wallet CLI Prototype
WALLET_FILE="$HOME/.zion_wallet_data"
LOG_FILE="$HOME/.zion_wallet_log"

# Initialize Wallet if not exists
if [ ! -f "$WALLET_FILE" ]; then
    echo "BALANCE=1000" > "$WALLET_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Wallet initialized with 1000 ZION Coins" > "$LOG_FILE"
fi

source "$WALLET_FILE"

show_menu() {
    echo "================================="
    echo "       💎 ZION WALLET CLI 💎     "
    echo "================================="
    echo "1. เช็กยอดเงินคงเหลือ (Check Balance)"
    echo "2. โอนเงิน (Transfer Coins)"
    echo "3. เติมเงิน (Top-up Coins)"
    echo "4. ดูประวัติธุรกรรม (Transaction History)"
    echo "5. ออกจากโปรแกรม (Exit)"
    echo "================================="
    read -p "เลือกเมนู [1-5]: " choice
    case $choice in
        1) check_balance ;;
        2) transfer_coins ;;
        3) topup_coins ;;
        4) view_history ;;
        5) exit 0 ;;
        *) echo "❌ ตัวเลือกไม่ถูกต้อง!"; sleep 1; show_menu ;;
    esac
}

check_balance() {
    echo -e "\n💰 ยอดเงินคงเหลือของคุณ: $BALANCE ZION Coins"
    echo "================================="
    read -p "กด Enter เพื่อกลับเมนูหลัก..."
    show_menu
}

transfer_coins() {
    echo -e "\n💸 -- โอนเงิน --"
    read -p "ระบุ Username ผู้รับ: " recipient
    read -p "ระบุจำนวน Coin ที่ต้องการโอน: " amount
    
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
    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        echo "ยังไม่มีประวัติการทำรายการ"
    fi
    echo "================================="
    read -p "กด Enter เพื่อกลับเมนูหลัก..."
    show_menu
}

# ให้สิทธิ์การรันไฟล์
chmod +x scripts/check_wallet.sh

# เรียกใช้งานเมนู
show_menu
