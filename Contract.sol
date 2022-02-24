pragma solidity 0.5.16;
contract Contract{

    struct User{
        string FIO;
        uint balance;
        string login;
    }
    mapping(string => address) public logins;
    mapping(address => User) public users;
    address root = msg.sender;

    function create_user(string memory login, string memory FIO) public{
        require(logins[login] == 0x0000000000000000000000000000000000000000, "This login is already exist");
        require(bytes(users[msg.sender].FIO).length == 0, "This ETH address is already registered");
        logins[login] = msg.sender;
        users[msg.sender] = User(FIO, msg.sender.balance, login);
    }

    function get_balance(address user_address) public view returns(uint){
        return(users[user_address].balance);
    }

    function send_money(address payable adr_to) payable public {
        adr_to.transfer(msg.value);
    }

    struct Donation{
        uint donate_id;
        string name;
        address payable user;
        uint amount;
        uint deadline;
        address[] sender;
        uint[] value;
        bool status;
        string info;
    }

    Donation[] donations;

    function ask_to_donate(string memory name, uint amount, uint deadline, string memory info) public {
        address[] memory sender;
        uint[] memory value;
        donations.push(Donation(donations.length, name, payable(msg.sender), amount, deadline, sender, value, true, info));
    }

    function participate(uint donation_id) public payable{
        require(donations[donation_id].status == true);
        require(msg.value > 0);
        donations[donation_id].sender.push(msg.sender);
        donations[donation_id].value.push(msg.value);
    }

    function get_donation(uint donation_id) public view returns(uint, string memory, address payable, uint, uint, bool){
        return(donation_id, donations[donation_id].name, donations[donation_id].user, donations[donation_id].amount, donations[donation_id].deadline, donations[donation_id].status);
    }
    function get_donation_2(uint donation_id) public view returns(address[] memory, uint[] memory, string memory) {
        return(donations[donation_id].sender, donations[donation_id].value, donations[donation_id].info);
    }

    function get_donation_number() public view returns(uint) {
        return (donations.length);
    }

    function get_total(uint donation_id) public view returns(uint){
        uint total = 0;
        for (uint i = 0; i > donations[donation_id].value.length; i++){
            total =total + donations[donation_id].value[i]; }
        return total;
    }

    function finish(uint donation_id) public{
        require(msg.sender != donations[donation_id].user);
        require(donations[donation_id].status == false);
        uint total = get_total(donation_id);
        if (total ** 2 >= donations[donation_id].amount){
            donations[donation_id].user.transfer(total);
        }
        else{
            for (uint i = 0; i < donations[donation_id].value.length; i++){
                payable(donations[donation_id].sender[i+1]).transfer(donations[donation_id].value[i]);
            }
        }
        donations[donation_id].status = false;
    }

}
