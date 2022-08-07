import { room } from "./room";
import { getGameStatus, STOPPED } from "./gameStatus";
import { RED_TEAM, BLUE_TEAM } from "./teams";

var redPlayers = [];
var bluePlayers = [];

function getRedPlayers() {
    return redPlayers;
}

function getBluePlayers() {
    return bluePlayers;
}

function setTeamPlayers() {
  if (getGameStatus() === STOPPED) { return; }

  redPlayers = room.getPlayerList().filter(function(player) { return player.team == RED_TEAM });
  bluePlayers = room.getPlayerList().filter(function(player) { return player.team == BLUE_TEAM });
}

export { getRedPlayers, getBluePlayers, setTeamPlayers };
