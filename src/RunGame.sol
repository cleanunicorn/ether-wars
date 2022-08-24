// SPDX-License-Identifier: MIT
import {Game} from  "./Game.sol";
import {Player as Player1} from "./Player1.sol";
import {Player as Player2} from "./Player2.sol";
import {IPlayer} from "./IPlayer.sol";

import "forge-std/console.sol";

contract RunGame {
    Game game;
    address[] players;

    constructor() {
        uint256 maxNumber = 16;
        game = new Game(maxNumber);

        IPlayer player1 = new Player1(game);
        IPlayer player2 = new Player2(game);

        players.push(address(player1));
        players.push(address(player2));
    }

    function run() public {
        // Register players
        for (uint256 playerIndex = 0; playerIndex < players.length; playerIndex++) {
            game.registerPlayer(IPlayer(players[playerIndex]));
        }

        game.play();

        IPlayer winner = game.winner();
        console.log(string(abi.encodePacked('Winner: ', winner.name())));
    }
}