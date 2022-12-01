from brownie import accounts, config, Cprescription,network

def get_account(): #parameter string role
    if(network.show_active() == "development"):
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])
    
    """if(role == 'patient'):
        if(network.show_active() == "development"):
            return accounts[0]
        else:
            return accounts.add(config["wallets"]["from_key"])
    else if(role == 'doctor')
        if(network.show_active() == "development"):
            return accounts[0]
        else:
             return accounts.add(config["wallets"]["from_key"])
             """




#def get_account(index=None):
 #   if index:
 #       return accounts[index]
  #  if not is_local_chain():
  #      return accounts[0]
  #  else:
        # for use with method 1)
        # return accounts.add(config["wallets"]["from_key"])
        # for use with method 2)
        # return accounts.load("your-account-id") 
