//SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract SimpleStorage {

    // this will get initialized to 0
    uint256 favoriteNumber;
    bool favoriteBool;

    //Struct creates a new object or  type , with parameters favoriteNumber and name of the types unit256 and name 
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    //view, pure are the ways to view a result without passing a transaction through the blockchain 

    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

        //memory only stores in execution and removes after 
        //storage stores wll persist
        //call datas are also temporary
    
    //call data - if youre going to remodify temporary variables
    //memory - if youre going to not remodify temporary variables
    //storage - you can remodify these permanent variables
    

    //arrays , structs, or mappings memory location cannot be defined 


    function addPerson(string memory _name, uint256 _favoriteNumber) public{
      people.push(People(_favoriteNumber, _name));
      nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}