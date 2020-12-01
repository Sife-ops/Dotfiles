#! /usr/bin/env python2
from subprocess import check_output

gnupghome = '/home/wyatt/.local/share/gnupg/'
def get_pass(pwfile):
    return check_output("/usr/bin/gpg --homedir "+gnupghome+" -dq "+gnupghome+pwfile, shell=True).strip("\n")
