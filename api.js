import {ethers} from "ethers";
import Web3modal from "web3modal";
import {smartc} from "C:\Users\swath\hackothon-141023\smartc.sol";
export const Checkusername =async() =>{
    try{
        if(username!=undefined) return console.log('username created.');
        else return console.log('username already exists');
    }catch(error){
        console.log(error)
    }
}