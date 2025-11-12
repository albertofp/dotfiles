## Linux OS fundamentals

### Technical 

- process/process management
- package management
- linux boot process
- memory management
- shells
- hardening server
- networking
- TLS/cert authorities/how they contribute to security in networks
- load balancing (cache, cdn, lb)

### Stories

- how ive debugged stuff in real life
- approach to troubleshooting (walk through method, tools used etc)
    - tell me about a significant issue you resolved (approach, resolution steps, tools used, prevention measures)
- live problem solving of a scenario
- results (what improved/how much, what did you automate and what was the manual process)
- STAR method (Situation, Task, Action, Result)
    - start with data (hard metrics showing what the propblem was, metrics)
    - task: what was my responsibilities and constraints
    - action: what tools, processes, techniques did i use? What was the solution and how did I validate it?
    - result: metrics? business value? long term impact?

### Scripting task

- based on real world scenarios
- assess problem solving skills, understanding of automation
- any language
- basic IDE is provided with no syntax checking or debugger
- ask clarifying questions (task _may_ be intentionally ambiguous)
- discuss thought process
- consider edge cases and unexpected inputs or errors
- comments
- consider modularity and reuse
- discuss possible improvements
- how do you ensure it's maintainable
- *SYSTEMATIC APPROACH TO PROBLEM SOLVING*
- enthusiasm to learn and staying up to date with tech (-> youtube videos, blogs, books and personal projects)

# Interview 1

## STAR responses based on LPs

### Invent and Simplify

*S*: Frequent requests coming in from devs regarding IAM permission (gcp roles, github repos, kubernetes RBAC)
*T*: Automate away frequent simple tickets
*A*: Build an internal tool that allows devs to assign themselves/their teams permissions via simple YAML config files.  Team leads have permission to approve changes within their own teams. This is now all managed by terraform in the tool instead of just via the UI on GCP.
*R*: Almost 100% of simple requests are solved internally within teams, permissions are kept track of in code and the infra team benefits from less context switching.

### Customer Obsession, Ownership

*S*: At Epsilico, we were growing our cloud usage fast and would frequently lose days waiting for quotas to be adjusted.
*T*: Make sure we always have enough resources to meet our needs.
*A*: Set up monitoring and alerts for quotas, proactively adjusted them and informed my superiors afterwards.  Introduced autoscaling for previously fixed size resources.

### Dive Deep, Bias for Action

*S*: SLURM cluster was cumbersome to use, requiring a lot of manual processes and hard to monitor. Deployment process was very slow.
*T*: Improve user experience and efficiency of SLURM cluster.
*A*:
    - Got permission to enroll in CKA course and take the exam.
    - Moved from SLURM to Kubernetes
    - Split container images into smaller, composable pieces
    - Optimized Docker images, reducing total container size from 60Gb to 17Gb, parallelizing builds and automating deployments.
    - Created templates for devs to submit compute jobs
    - Introduced monitoring with Prometheus and Grafana
*R*: 
    - less resource usage due to cluster scaling down to 0 when idle
    - 3-4x faster builds
    - reduced time wasted on misconfiguration of jobs.
    - easier and more granular monitoring of jobs

### Disagree and Commit

*S*: Boss wanted me to work on our Chatops tool that is used for deployments in Kubernetes. I fundamentally disagreed with the usage of the tool and would prefer to move towards a GitOps approach.
*T*: Maintain the tool, but show the value of GitOps and pave the way for future adoption.
*A*: 
    - Refactoring of the tool to be more GitOps friendly (-> commits files to repo)
    - Script to automate grouping services into ArgoCD apps
    - Add Cronjob to warn of K8s drift
    - Enable ArgoCD auto apply on infra team repositories (including the chatops tool) and encourage other teams to do the same (talks, documentation)
*R*: Auto apply is enabled for all infra repos, being adopted by another team. Chatops tool still widely in use, hopefully phased out with time.

## OSI Layers

| Layer                | Purpose                               | Examples             |
| -------------------- | ------------------------------------- | -------------------- |
| **7 – Application**  | User-facing protocols                 | HTTP, DNS, SMTP      |
| **6 – Presentation** | Data formatting, encryption           | TLS, SSL, JSON, MIME |
| **5 – Session**      | Connection management                 | NetBIOS, RPC         |
| **4 – Transport**    | End-to-end communication, reliability | TCP, UDP             |
| **3 – Network**      | Logical addressing and routing        | IP, ICMP             |
| **2 – Data Link**    | Physical addressing, framing          | Ethernet, ARP        |
| **1 – Physical**     | Transmission over medium              | Fiber, copper, Wi-Fi |

## TCP Handshake

TCP vs UDP

TCP
- guarantees delivery of data
- ordered

UDP
- no guarantees of delivery
- unordered
- more performant (good for live streaming)

### Tools

- `nc`: TCP/UDP connection
- `curl`: HTTP request

### TCP Handshake

1. SYN: Client → Server (request to open connection, sends seq=x).
2. SYN-ACK: Server → Client (ack=x+1, seq=y).
3. ACK: Client → Server (ack=y+1). Connection established.

## DNS

### Record Types

| Type | Purpose
| ---- | -------
| A    | IPv4 address
| AAAA | IPv6 address
| CNAME| Alias to another domain
| MX   | Mail exchange
| NS   | Name server
| TXT    | Text record (SPF/DKIM), authorizing

### Tools

- `dig`: DNS lookup
- `nslookup`: DNS lookup
- `host`

### TLS Certs

Contain public key, subject, issuer, validity period.

Chain of Trust:
Root CA → Intermediate CA → Leaf certificate

### Load Balancing

Levels

L4 (Transport): Balances based on IP/port. Doesn’t inspect payload.
Examples: AWS NLB, HAProxy (TCP mode).
Pros: Fast, low overhead. Cons: No app-level decisions.

L7 (Application): Inspects HTTP headers, cookies, URLs.
Examples: AWS ALB, NGINX, Envoy.
Pros: Smart routing, SSL termination, caching. Cons: Slightly higher latency.

Algorithms

- Round Robin
- Least Connections
- IP Hash / Consistent Hashing
- Weighted Balancing

### Process Management

Each process has a PID, parent PID, state, and resource limits. Managed via the kernel scheduler.

ps aux | grep nginx            # View processes
top / htop                    # Live CPU/mem usage
systemctl status nginx        # Check service state
kill -9 <pid>                 # Force terminate
strace -p <pid>               # Trace syscalls
lsof -p <pid>                 # Open files by process

Troubleshooting

Zombie processes: show as <defunct>. Usually due to parent not waiting for child.
Fix: restart parent or reassign to PID 1.
Runaway CPU: identify via top, then renice or limit via cgroups.
Memory leaks: inspect /proc/<pid>/smaps or pmap <pid>.

### Package Management 

Package managers (apt, dnf, pacman) resolve dependencies and verify integrity using GPG keys.

### Linux Boot Process

BIOS/UEFI → Bootloader (GRUB) → Kernel → initramfs → systemd

journalctl -b -1               # Logs from previous boot
systemctl list-dependencies    # View boot order
lsinitramfs /boot/initrd.img-* # Inspect initramfs

Troubleshooting

Boot hang: check kernel params in GRUB (systemd.unit=rescue.target)
Kernel panic: use recovery mode and rebuild initramfs (update-initramfs -u)
Missing root FS: verify fstab UUIDs match disks

### Memory Management

free -h
vmstat 1
cat /proc/meminfo
dmesg | grep -i oom

Troubleshooting

OOM kills: increase swap or adjust pod/container limits.
Memory leaks: use smem or ps_mem to identify high-resident memory processes.
Page cache pressure: echo 3 > /proc/sys/vm/drop_caches (temporary).
