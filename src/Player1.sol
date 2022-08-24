import { IPlayer } from "./IPlayer.sol";
import { Game } from "./Game.sol";

contract Player is IPlayer {
    Game game; 

    uint256 lastGuess;

    constructor(Game game_) {
        game = game_;
    }

    function name() public pure returns (string memory) {
        return "Joe";
    }
    function makeGuess() public {
        // uint256 guess = uint256(blockhash(block.number - 1)) % game.maxNumber();

        game.guess(lastGuess++);
    }
}