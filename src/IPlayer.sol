interface IPlayer {
    function name() external view returns (string memory);
    function makeGuess() external;
}