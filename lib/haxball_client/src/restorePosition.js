/******************************************************************************
 *
 *  Restore player position on disconnect
 *
 * ****************************************************************************/

import { room } from "./room";
import { e } from "./emojis";
import { setGameStatus, getGameStatus, STOPPED, PAUSED } from "./gameStatus";
import { randomInt } from "./utils";
import { SPECTATORS } from "./teams";

var playerPositions = {};

function clearPlayerPositions() {
  playerPositions = {};
}

function storePlayerPositions() {
  if (room.getScores() == null) return;

  var players = room.getPlayerList();
  players.forEach(function(player) {
    if (player.team == SPECTATORS) return;
    if (playerPositions[player.name] == undefined) {
      playerPositions[player.name] = {};
    }
    // Don't store new positions if the restore has been enabled
    if (playerPositions[player.name].restoreEnabled) { return }

    playerPositions[player.name] = {
      x: player.position.x,
      y: player.position.y,
      team: player.team,
      restoreEnabled: false
    };
  });
}

function restorePosition(player) {
  if (getGameStatus() == STOPPED) return;
  if (playerPositions[player.name] == undefined) return;
  if (!playerPositions[player.name].restoreEnabled) return;

  if (getGameStatus() != PAUSED) {
    room.pauseGame(true);
  }

  room.setPlayerTeam(player.id, playerPositions[player.name].team);
  room.setPlayerDiscProperties(player.id, {
    x: playerPositions[player.name].x,
    y: playerPositions[player.name].y,
  });

  playerPositions[player.name].restoreEnabled = false;
  room.sendAnnouncement(e("faceWithRollingEyes") + " Devolviendo la posicion a " + player.name);
}

function handleRestorePositionPlayerLeave(player) {
  if (randomInt(3) == 0) {
    room.sendAnnouncement(e("faceWithSymbolsOverMouth") + "Rage quit " + player.name + "?", null);
  }

  if (player.team == SPECTATORS) return;

  room.pauseGame(true);
  playerPositions[player.name].restoreEnabled = true;
  room.sendAnnouncement(e("redExclamationMark") + "Pausa. Se fue " + player.name + ".", null);
}

export {
  clearPlayerPositions,
  handleRestorePositionPlayerLeave,
  restorePosition,
  storePlayerPositions
};
