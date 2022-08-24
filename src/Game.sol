import "forge-std/console.sol";

import {IPlayer} from "./IPlayer.sol";

enum GuessResult {
    TOO_LOW,
    TOO_HIGH,
    EQUAL
}

contract Game {
    uint256 internal number;
    uint256 public maxNumber;

    bool finished;

    uint256 winnerIndex;

    // List of players
    IPlayer[] players;

    // Mapping Player contract address to index
    mapping(address => uint256) playerAddressToIndex;

    constructor(uint256 max_) {
        // Save max possible number
        maxNumber = max_;

        // Save the random number
        number = uint256(
            uint256(
                keccak256(
                    abi.encodePacked(blockhash(block.number - 1))
                )
            ) 
            % max_
        );

        console.log("Secret number is");
        console.log(number);
        console.log("");
    }

    function registerPlayer(IPlayer player_) public {
        uint256 playerIndex = players.length;
        players.push(player_);
        playerAddressToIndex[address(player_)] = playerIndex;
    }

    function playRound() public {
        uint256[] memory playerIndexes = new uint256[](players.length);
        // TODO: shuffle players instead of default order
        for (uint256 playerIndex = 0; playerIndex < players.length; playerIndex++) {
            playerIndexes[playerIndex] = playerIndex;
        }

        for(uint256 playerIndex = 0; playerIndex < players.length; playerIndex++) {
            IPlayer player = players[playerIndexes[playerIndex]];

            player.makeGuess();
        }
    }

    function guess(uint256 guessedNumber_) public returns (GuessResult) {
        GuessResult guessResult = _guess(guessedNumber_);

        console.log(string(abi.encodePacked(
            "Player ", IPlayer(msg.sender).name(), " tried "
        )));
        console.log(guessedNumber_);
        
        if (guessResult == GuessResult.TOO_HIGH) {
            console.log("too high");
        } else if (guessResult == GuessResult.TOO_LOW) {
            console.log("too low");
        } else {
            console.log("just right");
        }
        console.log("");

        return guessResult;
    }

    function _guess(uint256 guessedNumber_) internal returns (GuessResult) {
        // Return if the guessed number is high, low or equal
        if (guessedNumber_ > number) {
            return GuessResult.TOO_HIGH;
        } else if (guessedNumber_ < number) {
            return GuessResult.TOO_LOW;
        } 

        // Save winner
        winnerIndex = playerAddressToIndex[msg.sender];

        // Finish game
        finished = true;

        return GuessResult.EQUAL;
    }

    function play() public {
        console.log('Starting game');

        uint256 maxRounds = 10;
        uint256 round = 0;

        while (!finished && round < maxRounds) {
            round++;
            playRound();
        }

        console.log('Game ended');
    }

    function winner() public returns (IPlayer) {
        return players[winnerIndex];
    }
}