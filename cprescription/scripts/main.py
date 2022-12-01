from brownie import accounts, config, Cprescription,network
from scripts.accountManager import get_account
from scripts.deploy import deploy_Cprescription_Contract
from scripts.createDoctor import setDoctor
from scripts.createPatient import setPatientData
from scripts.signingPatient import doctorSign
from scripts.setPrescription import writeMedicine
from scripts.getPrescription import getPrescription

def main():
    account = get_account()
    contract_address = deploy_Cprescription_Contract()
    print(type(contract_address))
    setDoctor(contract_address,account,"Dr. Karim","Neurologist")
    setPatientData(contract_address,"Mohidul","Fever",28)
    patient_address = contract_address.pidList(0)
    print(contract_address.patientList((contract_address.pidList(0))))
    doctorSign(contract_address,patient_address,account)
    writeMedicine(contract_address,patient_address,"Napa")
    print(contract_address.patientList((contract_address.pidList(0))))
    print(contract_address.prescriptionList(patient_address))
    
    print(type(getPrescription(contract_address,patient_address)))  #should provide prescription object

