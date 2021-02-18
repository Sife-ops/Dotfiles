#! /usr/bin/env python2
from subprocess import check_output

secrets = '/home/wyatt/.local/share/secrets/'
def get_pass(pwfile):
    return check_output("/usr/bin/gpg --homedir "+secrets+" -dq "+secrets+pwfile, shell=True).strip("\n")
