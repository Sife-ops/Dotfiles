#! /usr/bin/env python2
from subprocess import check_output

homedir = '/home/wyatt/.local/share/gnupg/'
secrets = '/home/wyatt/.local/share/secrets/'
def get_pass(pwfile):
    return check_output("/usr/bin/gpg --homedir "+homedir+" -dq "+secrets+pwfile, shell=True).strip("\n")
