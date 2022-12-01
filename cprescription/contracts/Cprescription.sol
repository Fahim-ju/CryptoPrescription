// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;
import "@OpenZeppelin/contracts/access/Ownable.sol";

contract Cprescription is Ownable{
     uint public pidCount=0;
    //uint public withdrawCount;
    uint public doctorCount=0;
    ///*** setting up strucks
    uint public patientQueueCountFront=0;
    uint public patientQueueCountBack=0;

    address adminAddress;

    struct Patient {
        uint256 time;
        string name;
        uint age;
        string disease;
        string doctorName;
        address doctorAddress;
        address patientID;
        bool pidAvailable;
        bool doctorSignature;
        string medicine;   //used in writeMedicine
    }

    struct Doctor{
        address docAdress;
        string docName;
        string docSpecialization;
    }

//medicine view history
    struct withdrawHistory {
        address pid;
        string doctorName;
        uint256 time;
        string medicine;   //used in writeMedicine
        string patientName;
    }

    //prescription
    struct prescription{
        address pid;
        string patientName;
        address doctorAddress;
        uint256 time;
        uint256 age;
        string medicine;
    }

    //******Mapping
    mapping(address => bool) public doctorList;
    mapping(uint256 => address) public pidList;
    mapping(address => Patient) public patientList;
    mapping(address => Doctor) public doctorDetailList;
    mapping(uint256 => address) public docAddressList;
    //p_id to checkup mapping
    mapping(address  => prescription) public prescriptionList;
    //patientqueuelist who asks for doctor
    mapping(uint256 => address) patientQueueIdList;
    mapping(address => Patient) public patientQueueList; ///diseases are sympstom in this case


    function askForDoctor(string memory _name, uint256 _age, string memory sympstom) public {
        patientQueueIdList[patientQueueCountBack] = msg.sender;
        patientQueueList[msg.sender] = Patient(block.timestamp,_name,_age,sympstom,' ',0x0000000000000000000000000000000000000000,msg.sender,true,false," ");
        patientQueueCountBack++;
    }


    //Function to add a New Patient
 
    function setPatientData(string memory _name, string memory _disease,uint _age) public onlyOwner{
        require(patientQueueCountFront <= patientQueueCountBack, "All Patient Already Set");
        address pid = patientQueueIdList[patientQueueCountFront];
        patientQueueCountFront++;
        patientList[pid] = Patient(block.timestamp,_name,_age,_disease,' ',0x0000000000000000000000000000000000000000,pid,true,false," ");     
        //Increasing Patient Count by 1
        pidList[pidCount] = pid;
        pidCount++;
    }


    // Add a New DOCTOR
    function setDoctor(address _docAddress,string memory _name, string memory _spec) public onlyOwner{
        require(!doctorList[_docAddress],"You are not authorised to create doctor profile");
        doctorList[_docAddress] = true;
        doctorDetailList[_docAddress].docAdress = _docAddress;
        doctorDetailList[_docAddress].docName = _name;
        doctorDetailList[_docAddress].docSpecialization = _spec;
        docAddressList[doctorCount] = _docAddress;
        doctorCount++;
    }
    

//This function can only be called by a Doctor in the network
//doctor signtanure when observe patient
///**medicine should be added                                                       ///admin use this function to assign doctor to patient
    function doctorSign(address _pid,address doctorAddress) public onlyOwner{
        require(doctorList[doctorAddress],"You have to be a Admin to use this function");
        patientList[_pid].doctorSignature = true;
        patientList[_pid].doctorAddress = doctorAddress;
        patientList[_pid].doctorName = doctorDetailList[doctorAddress].docName;
    }



    //Writing prescription : doctor
    //first check signed or not
    function writeMedicine(address _pid,string memory _medicine) public {  //payable
        require(doctorList[msg.sender] == true,"You have to be a Doctor to use this function") ;//caller doctor or not
        require(patientList[_pid].doctorAddress == msg.sender, "You are not assigned to the patient");    //first check signed or not
         patientList[_pid].medicine = _medicine;
        //donorList[msg.sender] = msg.value;
       // CheckupHistory[_pid] = _medicine
        prescriptionList[_pid] = prescription(_pid, patientList[_pid].name,msg.sender ,block.timestamp,patientList[_pid].age,_medicine);
    }




//Withdrawing Funds from Patient // withdrawing medicine details from patient
    function getPrescription(address _pid) public view returns(prescription memory p){
        // Checkpoints Before execution
        require((doctorList[msg.sender]) || (patientList[_pid].patientID == msg.sender), "Your are not Authorised to view this prescription");
        
        return p = prescriptionList[_pid];   //return prescription object ***********
        
      //  require(patientList[_pid].insuranceAmount >= _amountRequired);
        
        // If all Conditions are satisfied, Funds are transferred to the assigned doctor
        //address payable recepientDoctor = msg.sender;
      //  patientList[_pid].insuranceAmount -= _amountRequired; 
        //recepientDoctor.transfer(_amountRequired);
        
        // Entire History of Withdrawal of Funds is stored on Blockchain
       // withdrawHistoryList[withdrawCount] = withdrawHistory(_pid, patientList[_pid].doctorName,now,_amountRequired,patientList[_pid].name);
        
    }

    // function callForDoctor()

}
