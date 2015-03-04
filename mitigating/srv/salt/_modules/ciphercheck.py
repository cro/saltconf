import os
import subprocess
import re

def openssl_ciphers():
    '''
    Return ciphers that OpenSSL knows about
    '''
    ciphers = []
    cipherstring = os.popen('openssl ciphers').read()
    cipherlist = cipherstring.rstrip().split(':')
    for c in cipherlist:
        if c.startswith('EXP-'):
            ciphers.append(c)

    return ciphers

def check_server_for_cipher(hostname=None, cipher=None):
    '''
    Contact the webserver at the passed hostname, forcing
    the passed cipher.  If the connection is successful,
    then the cipher is active.  Results are
    a dictionary

    result: Cipher present or NOT present
    cipher: the tested cipher
    success: True if cipher present, False if not present, None if error testing
    message: Extra information about the connection attempt
    '''
    if not hostname.endswith(':443'):
        hostname = hostname + ':443'

    cmd = '/usr/bin/openssl s_client -cipher {0} -connect {1} < /dev/null'.format(cipher, hostname)
    proc = subprocess.Popen(cmd, shell=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    connect_result = proc.communicate()[0]

    for line in connect_result.splitlines():
        if line.lstrip().startswith('Cipher') and line.endswith(cipher):
            return {'result':'Cipher Present',
                    'cipher':cipher,
                    'success':True}
        if 'sslv3 alert handshake failure' in line:
            return {'result':'Cipher NOT present',
                    'cipher':cipher,
                    'message':'SSLv3 handshake alert',
                    'success':False}

    if proc.returncode != 0:
        return {'result':'Unexpected OpenSSL Error',
                'cipher':cipher,
                'message':connect_result,
                'success':None}


    return {'result':'Cipher NOT present',
            'cipher':cipher,
            'success':False}

def run_export_ciphers(hostname):
    '''
    Retrieve all export ciphers that OpenSSL knows about
    and check to see if the hostname has those ciphers active on port 443.

    Returns a dictionary:
        success: is True if no ciphers active, False if one or more are active
        ciphers: a dictionary containing the individual test results
          'cipher name': present, not present, or an error message

    '''
    results = {}
    results['success'] = True
    cipher_results = {}
    ciphers = openssl_ciphers()
    for c in ciphers:
        ciphercheck = check_server_for_cipher(hostname=hostname, cipher=c)

        if ciphercheck['success'] is None:
            cipher_results[c] = 'Error: {0}'.format(ciphercheck['message'])
            results['success'] = None
        elif ciphercheck['success']:
            cipher_results[c] = 'present'
            results['success'] = False
        elif not ciphercheck['success']:
            cipher_results[c] = 'not present'

    results['ciphers'] = cipher_results

    return results

def server_check():
    '''
    Check the machine this function is running on for any 
    processes listening on port 443.  If there is a process listening
    on 443, enumerate any export ciphers, connect to port 443,
    negotiate SSL for each cipher present.  If the cipher negotiation
    is successful then this is bad, so return {'success':False} for
    that cipher.
    '''
    results = {}
    results['success'] = False

    ips = __salt__['whereis443.find']()
    if ips is None:
        results['success'] = True
    else:
        for ip in ips:
            results['ip'] = run_export_ciphers(ip)
            if results['ip']['success']:
                results['success'] = True

    return results
