pragma solidity 0.5.16;

contract SeaFood2 {
    struct User {// хранение данных о пользователе
        string login;
        string FIO;
        uint password;
    }
    struct Shop {//хранение данных о магазинах
        uint shopnumber;
        string city;
        address solidityadr;
    }
    struct Review {//хранение данных об отзывах
        uint shopnumber;
        string commentary;
        uint rating;
        string userLogin;
        uint likes;
        uint dislikes;
        uint level;
    }
    struct Request {// хранение данных о запросах смены роли
        uint role;
        address user;
        uint8 becomerole;
        bool finished;
        uint shopnumber;
    }
    struct Money {
        address payable shop;
        bool finished;
    }
    struct Item {
        string name;
        string manufacturer;
        uint date;
        uint expire;
        int32 mintemp;
        int32 maxtemp;
        uint count;
        bool kilo; //true - килограммы  false - штуки
        uint basecost;
    }
    struct Sell {
        uint itemId;
        uint count;
        uint mistemp;
    }
    User[] users;// массивы структур
    Item[] items;
    Sell[] sells;
    Shop[] shops;
    Review[] reviews;
    Request[] requests;
    Money[] moneys;
    uint[] shopsID;
    uint[] itemsId;
    mapping(address => uint8) role;// 0 - гость  1 - администратор  2 - поставщик  3 - магазин  4 - продавец  5 - покупатель
    mapping(address => uint) AddressToId;// маппинги для быстрого доступа к структурам по различным ключам
    mapping(address => uint) SellerToShopNumber;
    mapping(uint => uint[]) ShopToSellersID;
    mapping(uint => uint) Shopcredit;
    mapping(string => address) LoginToAddress;
    mapping(uint => uint[]) ShopToReviews;

    address payable bank_address = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address default_adr = 0x0000000000000000000000000000000000000000;
    constructor () public {
        shops.push(Shop(1,"Дмитров",0x9405a5D6263A6Da9EE3eD7D20924D82072DcD09E)); AddressToId[0x9405a5D6263A6Da9EE3eD7D20924D82072DcD09E] = shops.length-1; role[0x9405a5D6263A6Da9EE3eD7D20924D82072DcD09E] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(2,"Калуга",0x15E5318b537DDDbCeB6b1c383b1B71ea2CD61836)); AddressToId[0x15E5318b537DDDbCeB6b1c383b1B71ea2CD61836] = shops.length-1;role[0x15E5318b537DDDbCeB6b1c383b1B71ea2CD61836] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(3,"Москва",0xee5c85b89f7B5D7e930D46c2aC1265159FA986e2)); AddressToId[0xee5c85b89f7B5D7e930D46c2aC1265159FA986e2] = shops.length-1; role[0xee5c85b89f7B5D7e930D46c2aC1265159FA986e2] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(4,"Рязань",0xa2C7494ca423F1FBb9653fd4De10c0Fe59407A2c)); AddressToId[0xa2C7494ca423F1FBb9653fd4De10c0Fe59407A2c] = shops.length-1; role[0xa2C7494ca423F1FBb9653fd4De10c0Fe59407A2c] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(5,"Самара",0x9Df29117920155AcDFD3Afff9AA894f81e475cb4)); AddressToId[0x9Df29117920155AcDFD3Afff9AA894f81e475cb4] = shops.length-1; role[0x9Df29117920155AcDFD3Afff9AA894f81e475cb4] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(6,"Санкт-Петербург",0x1DDf573363BD3c4592ACdee5b8b75902c77216Dc)); AddressToId[0x1DDf573363BD3c4592ACdee5b8b75902c77216Dc] = shops.length-1; role[0x1DDf573363BD3c4592ACdee5b8b75902c77216Dc] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(7,"Таганрог",0x81C36245769f555A1d28202669f60d7675c44c8A)); AddressToId[0x81C36245769f555A1d28202669f60d7675c44c8A] = shops.length-1; role[0x81C36245769f555A1d28202669f60d7675c44c8A] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(8,"Томск",0x2555084AEa5DC3dDC541F81283da17511352DD52)); AddressToId[0x2555084AEa5DC3dDC541F81283da17511352DD52] = shops.length-1; role[0x2555084AEa5DC3dDC541F81283da17511352DD52] = 3;shopsID.push(shops.length-1);
        shops.push(Shop(9,"Хабаровск",0xF3071cc70CDd834D43d9B105893DF610f1F4108C)); AddressToId[0xF3071cc70CDd834D43d9B105893DF610f1F4108C] = shops.length-1; role[0xF3071cc70CDd834D43d9B105893DF610f1F4108C] = 3;shopsID.push(shops.length-1);

        users.push(User("goldfish","",123123));role[0x9Db07587eDffc0d798aDACD5DC45a03c7B490af9] = 2; AddressToId[0x9Db07587eDffc0d798aDACD5DC45a03c7B490af9] = users.length-1;LoginToAddress["goldfish"] = 0x9Db07587eDffc0d798aDACD5DC45a03c7B490af9;
        users.push(User("ivan","Иванов Иван Иванович",123123));role[0x02A1B992e4395534fc93c7149a3353a4e85032a7] = 1;AddressToId[0x02A1B992e4395534fc93c7149a3353a4e85032a7] = users.length-1;LoginToAddress["ivan"] = 0x02A1B992e4395534fc93c7149a3353a4e85032a7;

        users.push(User("semen","Семенов Семен Семенович",123123)); role[0xC59214B16E3052107128686FAFE33c2cDeCbB9F2] = 4;
        AddressToId[0xC59214B16E3052107128686FAFE33c2cDeCbB9F2] = users.length-1;LoginToAddress["semen"] = 0xC59214B16E3052107128686FAFE33c2cDeCbB9F2;
        SellerToShopNumber[0xC59214B16E3052107128686FAFE33c2cDeCbB9F2] = 1;ShopToSellersID[1].push(users.length-1);
        users.push(User("ugin","Евгеньева Евгения Евгеньевна",123123)); role[0x1f31EDfc91B55635fBae7E8903020d758579d611] = 4;
        AddressToId[0x1f31EDfc91B55635fBae7E8903020d758579d611] = users.length-1;LoginToAddress["ugin"] = 0x1f31EDfc91B55635fBae7E8903020d758579d611;
        SellerToShopNumber[0x83f7F78AE2a3c9DDA27C0859fBB8dd6851873949] = 3;ShopToSellersID[3].push(users.length-1);
        users.push(User("dima","Дмитриев Дмитрий Дмитриевич",123123)); role[0x80A4fd16dA0CC996853cbAEeB161A889054F9D24] = 4;
        AddressToId[0x80A4fd16dA0CC996853cbAEeB161A889054F9D24] = users.length-1;LoginToAddress["dima"] = 0x80A4fd16dA0CC996853cbAEeB161A889054F9D24;
        SellerToShopNumber[0x8247C9ABD51abD78284Aa385a24d791989baDF3a] = 5;ShopToSellersID[5].push(users.length-1);

        users.push(User("vasya","Васильев Василий Васильевич",123123)); role[0x93641B9c7eb2A9d0F007887b4F5AC5593B754785] = 4;
        AddressToId[0x93641B9c7eb2A9d0F007887b4F5AC5593B754785] = users.length-1;LoginToAddress["vasya"] = 0x93641B9c7eb2A9d0F007887b4F5AC5593B754785;
        SellerToShopNumber[0x93641B9c7eb2A9d0F007887b4F5AC5593B754785] = 7;ShopToSellersID[7].push(users.length-1);

        users.push(User("igor","Игорев Игорь Игоревич",123123)); role[0x3bCDC5e3bD9EcBbb36EEC88563b61E7A56369ff7] = 4;
        AddressToId[0x3bCDC5e3bD9EcBbb36EEC88563b61E7A56369ff7] = users.length-1;LoginToAddress["vasya"] = 0x3bCDC5e3bD9EcBbb36EEC88563b61E7A56369ff7;
        SellerToShopNumber[0x3bCDC5e3bD9EcBbb36EEC88563b61E7A56369ff7] = 8;ShopToSellersID[8].push(users.length-1);

        users.push(User("petr","Петров Петр Петрович",123123));role[0xa17bF45A18F831df5430423A67f5E969169a09F7] = 5;AddressToId[0xa17bF45A18F831df5430423A67f5E969169a09F7] = users.length-1;LoginToAddress["petr"] = 0xa17bF45A18F831df5430423A67f5E969169a09F7;
        users.push(User("roman","Романов Роман Романович",123123));role[0x763fc9b68a43CDd60d0254321e90BF9D8EcF6135] = 5;AddressToId[0x763fc9b68a43CDd60d0254321e90BF9D8EcF6135] = users.length-1;LoginToAddress["roman"] = 0x763fc9b68a43CDd60d0254321e90BF9D8EcF6135;
        users.push(User("nikola","Николаев Николай Николаевич",123123));role[0x64cbE8c799bb959b1040aF0c4339edFBb8c9f652] = 5;AddressToId[0x64cbE8c799bb959b1040aF0c4339edFBb8c9f652] = users.length-1;LoginToAddress["nikola"] = 0x64cbE8c799bb959b1040aF0c4339edFBb8c9f652;
        users.push(User("oleg","Олегов Олег Олегович",123123));role[0x4438E76f00300942eed2c61773a0F944619d9e72] = 5;AddressToId[0x4438E76f00300942eed2c61773a0F944619d9e72] = users.length-1;LoginToAddress["oleg"] = 0x4438E76f00300942eed2c61773a0F944619d9e72;
        users.push(User("alex","Александрова Александра Александровна",123123));role[0x27B388B2417AAfAd87B3Ec806322Ef59ed4384f6] = 5;AddressToId[0x27B388B2417AAfAd87B3Ec806322Ef59ed4384f6] = users.length-1;LoginToAddress["alex"] = 0x27B388B2417AAfAd87B3Ec806322Ef59ed4384f6;

        reviews.push(Review(1,"Отличное качество товара",10,"oleg",25,0,0));ShopToReviews[0].push(reviews.length-1);
        reviews.push(Review(1,"подтверждаю",9,"petr",20,2,1));ShopToReviews[0].push(reviews.length-1);
        reviews.push(Review(1,"Быстрое обслуживание",9,"petr",15,1,0));ShopToReviews[0].push(reviews.length-1);
        reviews.push(Review(1,"А я долго ждал((",2,"nikola",0,11,1));ShopToReviews[0].push(reviews.length-1);
        reviews.push(Review(1,"Магазин приносит свои извинения за длительное ожидаение",0,"semen",40,15,2));ShopToReviews[0].push(reviews.length-1);
        reviews.push(Review(3,"Ничего особенного",5,"roman",3,20,0));ShopToReviews[2].push(reviews.length-1);
        reviews.push(Review(3,"Не согласен с вами, все супер!",10,"petr",15,0,1));ShopToReviews[2].push(reviews.length-1);
        reviews.push(Review(3,"Спасибо, мне все понравилось",8,"alex",23,1,0));ShopToReviews[2].push(reviews.length-1);
        reviews.push(Review(3,"И мне!",9,"roman",36,5,1));ShopToReviews[2].push(reviews.length-1);
        reviews.push(Review(8,"Мне нахамил продавец. Больше не приду к вам!",1,"alex",10,2,0));ShopToReviews[7].push(reviews.length-1);
        reviews.push(Review(8,"Поддерживаю, ужасный сервис!",2,"petr",11,0,1));ShopToReviews[7].push(reviews.length-1);
        reviews.push(Review(8,"Сервис в магазине на троечку.",3,"oleg",15,2,0));ShopToReviews[7].push(reviews.length-1);
    }
    modifier isAdmin() {// проверка роли
        require(role[msg.sender] == 1,"Вы не администратор");_;
    }
    modifier isRegistered() {// проверка регистрации
        require(role[msg.sender] != 0,"Вы не зарегистрированы");_;
    }
    modifier isBuyerOrSellerInThisShop(uint reviewID) {// проверка для отзывов
        require(role[msg.sender] == 5 || (role[msg.sender] == 4 && SellerToShopNumber[msg.sender] == reviews[reviewID].shopnumber));
        _;
    }
    // Функции вывода информации
    function getRole() public view isRegistered returns(uint) {
        return(role[msg.sender]);
    }
    function userInfo() public view isRegistered returns(string memory, string memory){
        return(users[AddressToId[msg.sender]].login,users[AddressToId[msg.sender]].FIO);
    }
    function getItemCost(uint itemid, uint count) public view returns(uint) {
        require(role[msg.sender] == 3,"Только магазин может закупать товары");
        uint K;
        if(count<=100){
            K = 100;
        }
        if(count>1000){
            K = 90;
        }
        else{
            K = 95;
        }
        return((items[itemid].basecost-items[itemid].basecost*getShopRating(AddressToId[msg.sender]+1)/100)*K*count);
    }
    function buyItemRequest(uint itemid,uint count,int8 temp1,int8 temp2,int8 temp3,int8 temp4,int8 temp5,int8 temp6) public payable {
        require(role[msg.sender] == 3,"Только магазин может закупать товары");
        require(msg.value == getItemCost(itemid,count),"Цена не совпадает с заявленной");
        uint a = 0;
        if(temp1<items[itemid].mintemp || temp1>items[itemid].maxtemp){a++;}
        if(temp2<items[itemid].mintemp || temp1>items[itemid].maxtemp){a++;}
        if(temp3<items[itemid].mintemp || temp1>items[itemid].maxtemp){a++;}
        if(temp4<items[itemid].mintemp || temp1>items[itemid].maxtemp){a++;}
        if(temp5<items[itemid].mintemp || temp1>items[itemid].maxtemp){a++;}
        if(temp6<items[itemid].mintemp || temp1>items[itemid].maxtemp){a++;}
        sells.push(Sell(itemid,count,a));

    }
    
    function getItemsId() public view returns(uint[] memory){
        return(itemsId);
    }
    function addressFromLogin(string memory login) public view returns(address) {
        return(LoginToAddress[login]);
    }
    function getShopsId() public view returns(uint[] memory){
        return(shopsID);
    }
    function getShop(uint shopID) public view returns(uint, string memory,address){
        return(shops[shopID].shopnumber,shops[shopID].city,shops[shopID].solidityadr);
    }
    function getShopSender() public view returns(uint, string memory,address){
        return(shops[AddressToId[msg.sender]].shopnumber,shops[AddressToId[msg.sender]].city,shops[AddressToId[msg.sender]].solidityadr);
    }
    function getReviewsId(uint shopnumber) public view returns(uint[] memory) {
        return(ShopToReviews[shopnumber]);
    }
    function getReview(uint reviewID) public view returns(uint,string memory,uint,string memory,uint,uint,uint){
        return(reviews[reviewID].shopnumber,reviews[reviewID].commentary,reviews[reviewID].rating,reviews[reviewID].userLogin,reviews[reviewID].likes,reviews[reviewID].dislikes,reviews[reviewID].level);
    }
    function getItem(uint itemId) public view returns(string memory, string memory, uint, uint,uint,bool,uint){
        require(role[msg.sender] == 3,"Только магазины могут просмотреть информацию о товарах");
        return(items[itemId].name,items[itemId].manufacturer,items[itemId].date,items[itemId].expire,items[itemId].count,items[itemId].kilo,items[itemId].basecost);
    }
    function getItemTemp(uint itemId) public view returns(int32,int32){
        return(items[itemId].mintemp,items[itemId].maxtemp);
    }
}