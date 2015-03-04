def find():
    '''
    Run 'netstat' and return a list of all
    addresses that are listening on port 443
    '''
    lstn = __salt__['network.netstat']()
    lstn_check = []

    for l in lstn:
        if l['local-address'].endswith(':443'):
            lstn_check.append(l['local-address'])

    if len(lstn_check) == 0:
        return None
    else:
        return lstn_check
