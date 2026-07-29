# MODERN APP ARCHITECTURE: AN 'ASSUME BREACH' CONTAINMENT STRATEGY
**Vulnerabilities happen.** The goal is **blast radius reduction**, not just prevention.

---

## THE REALITY & STRATEGY

### THE THREAT LANDSCAPE
- **Frontends (Next.js/RSC) are privileged backends.**
- **Zero-day exploits are inevitable.**
- **A compromised frontend is a gateway to data & secrets.**

### THE CONTAINMENT GOAL
- Assume RCE will occur.
- Neutralize the attacker's foothold immediately.
- Ensure no persistence, no lateral movement, no data exfiltration.

---

## THE CONTAINMENT CHECKLIST (ACTIONABLE DO'S)

### 1. DECOUPLE ARCHITECTURE (BFF PATTERN)
- ✓ **Isolate Frontend from Database**: No direct DB access or ORMs in UI code.
- ✓ Use a **dedicated Backend API (BFF)** for all data & logic.
- ✓ **Store sensitive credentials** only in the secure backend service.

### 2. HARDEN THE CONTAINER ENVIRONMENT
- ✓ Use **'Distroless' base images**: Remove shells (`/bin/sh`), package managers, and utilities like `curl`.
- ✓ **Enforce Read-Only Root Filesystem**: Prevent tool installation and persistence.
- ✓ **Run as Non-Root User**: Block privilege escalation to the host.

### 3. IMPLEMENT STRICT RUNTIME & NETWORK ISOLATION
- ✓ **Network Policy 'Default Deny'**: Block all outbound traffic; allow-list only DNS and BFF API.
- ✓ **Restrict Node.js Capabilities**: Use `--permission` flags to block `child_process` spawning.
- ✓ **Apply Seccomp Profiles**: Filter dangerous system calls at the kernel level.

