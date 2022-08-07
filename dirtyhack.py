import fileinput, subprocess, sys, time

file_name = "cmd/bg-switcherlet/main.go"
haddr = 8080
maddr = 9090
# routers = ["blue-a", "blue-b", "blue-c", "green-a", "green-b", "green-c"]
routers = ["blue-a", "green-a",]
for i, router_name in enumerate(routers):
    with fileinput.FileInput(file_name, inplace=True, backup=".bak") as f:
        for line in f:
            if "MADDR" in line:
                print(line.replace("MADDR", str(maddr+i)), end="")
            elif "HADDR" in line:
                print(line.replace("HADDR", str(haddr+i)), end="")
            else: print(line, end="")
    cp = subprocess.run([
        "docker", "build",
        "--file", "cmd/bg-switcherlet/Dockerfile",
        "--tag", router_name,
        "."
    ])
    time.sleep(1.0)
    if cp.returncode != 0:
        print("failed.", file=sys.stderr)
        sys.exit(1)
    with fileinput.FileInput(file_name, inplace=True, backup=".bak") as f:
        for line in f:
            if str(maddr+i) in line:
                print(line.replace(str(maddr+i), "MADDR"), end="")
            elif str(haddr+i) in line:
                print(line.replace(str(haddr+i), "HADDR"), end="")
            else: print(line, end="")