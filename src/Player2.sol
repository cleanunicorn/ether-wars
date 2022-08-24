import { IPlayer } from "./IPlayer.sol";
import { Game } from "./Game.sol";

contract Player is IPlayer {
    Game game; 

    uint256 lastGuess;

    constructor(Game game_) {
        game = game_;
        lastGuess = game_.maxNumber() - 1;
    }

    function name() public pure returns (string memory) {
        return "Jane";
    }
    function makeGuess() public {
        // uint256 guess = uint256(blockhash(block.number - 1)) % game.maxNumber();

        game.guess(lastGuess--);
    }
}