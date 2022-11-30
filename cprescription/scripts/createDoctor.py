

def setDoctor(contract_address,address,name,specialization):
    contract_address.setDoctor(address,name,specialization)
    print(contract_address.doctorDetailList(address))