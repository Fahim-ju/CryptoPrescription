from brownie import accounts, config, Cprescription,network
from accountManager import get_account

#import yaml
#with open('brownie-config.yaml', 'rt', encoding='utf8') as yml:
#    config = yaml.load(yml)

def deploy_simple_storage():
    #account = accounts[0]
    account = get_account()
    cprescription = Cprescription.deploy({"from": account})
    
    #account = accounts.load("my_test_account")
    #account  = accounts.add(os.getenv("PRIVATE_KEY"))
    #account = accounts.add(config['wallets']['from_key'])
    print(account)
    print(cprescription)
    return cprescription




def main():
    contract_address = deploy_simple_storage()
    contract_address.setPatientData("Jalil","Rahim",25)
    print(contract_address.patientList(contract_address.pidList(0)))