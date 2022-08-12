#!/usr/bin/env python3
import argparse
import os, sys
import subprocess
from time import sleep




def main():
    # init = subprocess.run("ip -s -j link | jq '.[].stats64.rx.packets' -r", encoding='utf-8', stdout=subprocess.PIPE)
    ifs = subprocess.check_output("ip -s -j link | jq '.[].ifname' -r", shell=True,encoding="UTF-8" )
    ifs = ifs.splitlines()
    init_rxs = subprocess.check_output("ip -s -j link | jq '.[].stats64.rx.packets' -r", shell=True, encoding="UTF-8")
    init_rxs = list(map(lambda res: int(res), init_rxs.splitlines()))
    init_txs = subprocess.check_output("ip -s -j link | jq '.[].stats64.tx.packets' -r", shell=True, encoding="UTF-8")
    init_txs = list(map(lambda res: int(res), init_txs.splitlines()))

    before_rxs = init_rxs
    before_txs = init_txs
    subprocess.run("clear")
    while True:
        sleep(0.5)
        rx = subprocess.check_output("ip -s -j link | jq '.[].stats64.rx.packets' -r", shell=True, encoding="UTF-8" )
        current_rxs = current_xx(rx, init_rxs)
        tx = subprocess.check_output("ip -s -j link | jq '.[].stats64.tx.packets' -r", shell=True, encoding="UTF-8" )
        current_txs = current_xx(tx, init_txs)
        res = 'hostname: ' + os.uname()[1] + '\n'
        res += '{:<10}  {:<20}  {:<20}\n'.format("interface", "rx", "tx")
        for i in range(len(ifs)):
            rx = str(current_rxs[i]) if current_rxs[i] - before_rxs[i] < 10 else Color.YELLOW + str(current_rxs[i]) + Color.END
            tx = str(current_txs[i]) if current_txs[i] - before_txs[i] < 10 else Color.YELLOW + str(current_txs[i]) + Color.END
            res += '{:<10}  {:<20}  {:<20}\n'.format(ifs[i], rx, tx)
        magic_char = '\033[F'
        ret_depth = magic_char * res.count('\n')
        print('{}{}'.format(ret_depth, res), end='', flush = True)
        before_rxs = current_rxs
        before_txs = current_txs

def current_xx(xx, init_xxs):
    xx_int = list(map(lambda res: int(res), xx.splitlines()))
    current_xxs = []
    for i, init_xx in enumerate(init_xxs):
        current_xxs.append(xx_int[i] - init_xx)    
    return current_xxs

class Color:
    BLACK     = '\033[30m'
    RED       = '\033[31m'
    GREEN     = '\033[32m'
    YELLOW    = '\033[33m'
    BLUE      = '\033[34m'
    PURPLE    = '\033[35m'
    CYAN      = '\033[36m'
    WHITE     = '\033[37m'
    END       = '\033[0m'
    BOLD      = '\038[1m'
    UNDERLINE = '\033[4m'
    INVISIBLE = '\033[08m'
    REVERCE   = '\033[07m'

if __name__ == '__main__': main()