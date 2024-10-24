// SPDX-License-Identifier: UNLICENSED
pragma solidity  ^0.8.17;

contract HoistHub{
    
    struct Campaign{
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        address[] donators;
        uint256[] donations;
    }

    //STORING CAMPAIGN DATA
    mapping(uint256 => Campaign) public campaigns; 

    //CAMAPAIGNS COUNT
    uint256 public numberOfCampaigns = 0;

    //CREATING CAMPAIGNS
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;            //there will be no fund in new campaign

        numberOfCampaigns++;                     //increase campaign count
        return numberOfCampaigns - 1;            //return created campaign
    }

    //DONATING TO A CAMPAIGN - we are no storing anything inside the contract, we are just pointing to owner address
    function donateToCampaign(uint256 _id) public payable{
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if (sent){ 
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    //GETTING DONORs INFO
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    //GET ALL CAMPAIGNS
    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[] (numberOfCampaigns);
        for(uint i = 0; i < numberOfCampaigns; i++){
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }
        return allCampaigns;
    }
}