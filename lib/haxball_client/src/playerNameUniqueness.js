import { room } from "./room";

function playerNameUniqueness(player) {
  var players = room.getPlayerList();
  var playerNames = players.map(p => p.name);
  playerNames.splice(playerNames.indexOf(player.name), 1);

  if (playerNames.indexOf(player.name) !== -1) {
    room.kickPlayer(player.id, "Ya ahi alguien con ese nombre conectado", false);
    return false;
  }

  return true;
}

export { playerNameUniqueness };
