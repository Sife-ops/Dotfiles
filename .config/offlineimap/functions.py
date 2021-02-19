#! /usr/bin/env python

from subprocess import os
from subprocess import check_output

homedir = os.path.expandvars("${GNUPGHOME}/")
secrets = os.path.expandvars("${SECRETS}/")

def get_pass(pwfile):
    return check_output("/usr/bin/gpg --homedir "+homedir+" -dq "+secrets+pwfile, shell=True).strip("\n")
