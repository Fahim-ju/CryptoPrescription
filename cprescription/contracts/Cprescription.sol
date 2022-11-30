// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;
import "@OpenZeppelin/contracts/access/Ownable.sol";

contract Cprescription is Ownable{
     uint public pidCount=0;
    //uint public withdrawCount;
    uint public doctorCount=0;
    ///*** setting up strucks

    struct Patient {
        uint256 time;
        //could be medicine
        // uint256 donatedAmount; string array
        string name;
        uint age;
        string disease;
        string doctorName;
        //string ipfsHash;
        address doctorAddress;
        address patientID;
        bool pidAvailable;
        bool doctorSignature;
        string medicine;   //used in writeMedicine
    }

    struct Doctor {
        address docAdress;
        string docName;
        string docSpecialization;
    }

//medicine view history
    struct withdrawHistory {
        address pid;
        string doctorName;
        uint256 time;
        //new  
        string medicine;   //used in writeMedicine
        //uint256 amount;
        string patientName;
    }
    //prescription

    struct prescription{
        address pid;
        string patientName;
        string doctorName;
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
    //mapping(address => string[]) public checkuplist;
  //  mapping(uint256 => withdrawHistory) public withdrawHistoryList;

    //Function to add a New Patient
 
    function setPatientData(string memory _name, string memory _disease,uint _age) public {
        //GENERATING a UNIQUE ID for Patient
        address pid = address(bytes20(keccak256(abi.encodePacked(msg.sender,block.timestamp))));
        patientList[pid] = Patient(block.timestamp,_name,_age,_disease,' ',0x0000000000000000000000000000000000000000,pid,true,false," ");     
        //Increasing Patient Count by 1
        pidList[pidCount] = pid;
        pidCount++;
    }


    // Add a New DOCTOR
    function setDoctor(address _docAddress,string memory _name, string memory _spec) public onlyOwner{
        require(!doctorList[_docAddress]);
        doctorList[_docAddress] = true;
        doctorDetailList[_docAddress].docAdress = _docAddress;
        doctorDetailList[_docAddress].docName = _name;
        doctorDetailList[_docAddress].docSpecialization = _spec;
        docAddressList[doctorCount] = _docAddress;
        doctorCount++;
    }
    
//This function can only be called by a Doctor in the network
//doctor signtanure when observe patient
///**medicine should be added
    function doctorSign(address _pid) public{
        require(doctorList[msg.sender]);
        patientList[_pid].doctorSignature = true;
        patientList[_pid].doctorAddress = msg.sender;
        patientList[_pid].doctorName = doctorDetailList[msg.sender].docName;
    }



    //Writing prescription : doctor
    //first check signed or not
    function writeMedicine(address _pid,string memory _medicine) public {  //payable
        require(doctorList[msg.sender] == true) ;//caller doctor or not
        require(patientList[_pid].doctorAddress == msg.sender);    //first check signed or not
         patientList[_pid].medicine = _medicine;
        //donorList[msg.sender] = msg.value;
       // CheckupHistory[_pid] = _medicine
        prescriptionList[_pid] = prescription(_pid, patientList[_pid].name,doctorDetailList[msg.sender].docName ,block.timestamp,patientList[_pid].age,_medicine);
    }




//Withdrawing Funds from Patient // withdrawing medicine details from patient
    function getPrescription(address _pid) public view returns(prescription memory p){
        // Checkpoints Before execution
        require((doctorList[msg.sender]) || (patientList[_pid].patientID == msg.sender));
        
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
