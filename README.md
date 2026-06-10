# DroidX v1.0

**Android Payload Builder (MSFvenom Wrapper)**

Generate Android Meterpreter payloads with an interactive menu. Works with or without Metasploit installed.

## One-Line Install

```bash
curl -sL https://raw.githubusercontent.com/AdhiHub/droidx/main/install.sh | sudo bash
```

## Features

| Feature | Description |
|---------|-------------|
| Reverse TCP | Create android/meterpreter/reverse_tcp payload |
| Bind Shell | Create android/meterpreter/bind_tcp payload |
| HTTPS | Create android/meterpreter/reverse_https payload |
| Smart Mode | If msfvenom is installed, generates APK; otherwise shows command |
| Listener Setup | Companion meterpreter listener command (or auto-start) |
| Payload Reference | Lists common Android payloads |
| Logging | Saves all commands to a timestamped file |

## Usage

```bash
# Interactive menu
./droidx.sh

# Show help
./droidx.sh -h
```

Menu options:
1. **Reverse TCP** - LHOST connects to your listener
2. **Bind Shell** - You connect to LHOST
3. **HTTPS** - Encrypted reverse connection
4. **List Payloads** - View common Android payloads
5. **Help** - Usage information

## Requirements

- Bash 4+
- curl
- Optional: Metasploit Framework (msfvenom, msfconsole)

Works on **Linux** and **Termux** (Android).

## Disclaimer

```
Use at your own risk. Developer(s) assume NO liability.
For authorized penetration testing and educational purposes only.
```
