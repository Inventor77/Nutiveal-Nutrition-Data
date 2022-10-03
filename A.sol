

contract auction is ReentrancyGuard {
    IERC721 public Nft_contract;

    enum auctionState {
        STARTED,
        ENDED
    }

    // token Id of the nft
    uint256 public nftId;

    // address of the seller
    address public seller;

    // starting price of NFT in Ether
    uint256 public basePrice;

    // Price in Ether of the current highest Bid
    uint256 public bidPrice;

    // Address of the current highest Bidder
    address public bidder;

    // Timestamp of the Auction to be finished
    uint256 private end_auction;

    // mapping bid Amount of buyer with Address
    mapping(address => uint256) public bids;

    // current state of the Auction
    auctionState private auction_State = auctionState.ENDED;

    /// ------------------------------------------------------
    /// Events
    /// ------------------------------------------------------

    event Start(address indexed _nft, uint256 _tokenId, uint256 _bidprice);
    event Bid(address indexed highestBidder, uint256 highestBid);
    event Withdraw(address indexed bidder, uint256 amount);
    event End(address indexed highestBidder, uint256 highestBid);

    constructor() {
        seller = msg.sender;
    }

    /// ------------------------------------------------------
    /// Seller actions
    /// ------------------------------------------------------

    // function to start Auction with NFT address , token Id and starting Price

    function startAuction(
        address _nft,
        uint256 _tokenId,
        uint256 _startingPrice
    ) public {
        require(seller == msg.sender, "caller is not the seller");
        require(auction_State == auctionState.ENDED, "auction not ended");
        Nft_contract = IERC721(_nft);

        // resets the previous auction data
        bidPrice = 0;
        bidder = address(0);

        nftId = _tokenId;
        basePrice = _startingPrice;
        // transfers NFT ownership from seller to contract
        Nft_contract.transferFrom(msg.sender, address(this), _tokenId);
        auction_State = auctionState.STARTED;
        end_auction = block.timestamp + 5 minutes;

        emit Start(_nft, _tokenId, _startingPrice);
    }

    // function to end auction when timestamp is over and distribute rewards accordingly
    // protects from re-entrancy(seller drains all funds)

    function endAuction() external nonReentrant {
        require(block.timestamp > end_auction, "auction not ended");
        require(auction_State == auctionState.STARTED, "auction already ended");

        if (bidder != address(0)) {
            // transfers ownership of NFT from contract to highest bidder
            Nft_contract.transferFrom(address(this), bidder, nftId);
            // sent the bidding amount to seller
            (bool sent, ) = payable(seller).call{value: bidPrice}("");
            require(sent, "Could not withdraw");
            bids[bidder] = 0;
        } else {
            // if these is no bidder then the NFT ownership is back to the seller
            Nft_contract.transferFrom(address(this), seller, nftId);
        }

        auction_State = auctionState.ENDED;
        emit End(bidder, bidPrice);
    }

    /// ------------------------------------------------------
    /// Users actions
    /// ------------------------------------------------------

    // function to bid in auction requries higher amount than the previous bid
    // or if no bid happens requries higher than the base price

    function bid() external payable {
        require(auction_State == auctionState.STARTED, "auction not started");
        require(end_auction > block.timestamp, "auction ended");

        // sums up the ether of user in contract and the extra bid amount
        uint256 _bidPrice = bids[msg.sender] + msg.value;
        require(
            _bidPrice > bidPrice && _bidPrice > basePrice,
            "bid amount is less the highest bid or base Price"
        );
        bidder = msg.sender;
        // replaces the previous bid amount of user with the new bid amount
        bids[msg.sender] = _bidPrice;
        bidPrice = _bidPrice;
        emit Bid(msg.sender, _bidPrice);
    }

    // function to withdraw bid amount by user at any time,
    // protects from re-entrancy(drains all fund amount)

    function withdrawBid() external nonReentrant {
        // checks whether highest bidder or not
        require(
            msg.sender != bidder,
            "current highest bidder allowed to withdraw "
        );

        uint256 balance = bids[msg.sender];
        require(balance > 0, "bid amount already withdrawn");
        bids[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: balance}("");
        require(sent, "Could not withdraw");
        emit Withdraw(msg.sender, balance);
    }
}