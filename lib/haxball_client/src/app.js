/*
 *  How to use?
 *  1. Go to https://www.haxball.com/headless
 *  2. Paste: var s=document.createElement('script');s.src='https://github.com/juanmanuelramallo/q/releases/latest/download/long.js';document.body.appendChild(s)
 *  3. GLHF
 *
 *  Features & roadmap:
 *  [x] 1) Gives admin to all users
 *  [x] 2) Sets longbounce as the stadium
 *  [x] 3) Records matches
 *  [ ] 4) Celebrations with avatars
 *  [x] 5) Commands to manage a game: restart and swap
 *  [x] 6) Global scoreboard
 *  [ ] 7) Pause on AFKs
 *  [ ] 8) Export scoreboard to a csv
 *  [x] 9) Pause on disconnect
 *  [ ] 10) New game mode? Portalhax, ball passes through portals
 */

import { handleEndGame } from "./endGame";
import { room } from "./room";
import {
  clearLastBallKicks,
  clearMatchPlayerStats,
  clearWinnerTeamId,
  handleScoreboardBallKick,
  handleScoreboardTeamGoal,
  handleScoreboardTeamVictory,
  initPersonalScoreboard,
  showScoreboardForPlayers,
  pauseScoreboard,
  isScoreboardPaused
} from "./scoreboard";
import { e } from "./emojis";
import {
  clearPlayerPositions,
  handleRestorePositionPlayerLeave,
  storePlayerPositions
} from "./restorePosition";
import { handleCommandsFromChat } from "./commands";
import { getGameStatus, setGameStatus, STARTED, STOPPED, PAUSED } from "./gameStatus";
import { playerNameUniqueness } from "./playerNameUniqueness";
import { sendHappyMessages, announcementMessages } from "./sendHappyMessages"
import { handleQ, handleEz, handleSry } from "./avatarMagic";
import { setTeamPlayers } from "./players";
import { playersElo } from "./playersElo";
import { startLoginTimeout } from "./login";

room.onGameTick = function() {
  storePlayerPositions();
  setTeamPlayers();
}

room.onPlayerChat = function(player, message) {
  const result = handleCommandsFromChat(player, message);

  if (message === 'q') {
    handleQ(player);
  } else if (message === 'ez') {
    handleEz(player);
  } else if (message === 'sry') {
    handleSry(player);
  }

  return result;
}

room.onPlayerLeave = function(player) {
  handleRestorePositionPlayerLeave(player);
}

room.onGameStart = function(byPlayer) {
  setGameStatus(STARTED);
  clearLastBallKicks();
  clearPlayerPositions();
  clearMatchPlayerStats();
  clearWinnerTeamId();
  room.startRecording();
}

room.onGameStop = function(byPlayer) {
  setGameStatus(STOPPED);
  clearWinnerTeamId();
}

room.onGamePause = function(byPlayer) {
  setGameStatus(PAUSED);
}

room.onPlayerBallKick = function(player) {
  handleScoreboardBallKick(player);
}

room.onTeamGoal = function(team) {
  if (isScoreboardPaused()) {
    room.sendAnnouncement(e("redExclamationMark") + " Scoreboard pausado (no se guardan stats, ni elo, ni recordings)");
  }

  handleScoreboardTeamGoal(team);

  const scores = room.getScores()
  const scoreLimit = scores.scoreLimit

  // If red or blue reached the score limit -> game finished
  if (scores.red == scoreLimit || scores.blue == scoreLimit) {
    handleScoreboardTeamVictory(scores)
    handleEndGame(room.stopRecording());
  }
}

async function initOnPlayerJoin() {
  let elos = await playersElo();

  room.onPlayerJoin = function(player) {
    const isUnique = playerNameUniqueness(player);
    if (!isUnique) { return }

    room.setPlayerAdmin(player.id, true);
    initPersonalScoreboard(player, elos[player.name]);
    showScoreboardForPlayers([player], false);
    announcementMessages(player.name);
    room.sendAnnouncement(e("redExclamationMark") + " Tenes 15s para loguear3 '!login PASSWORD'", player.id);
    startLoginTimeout(player);
  }
}

initOnPlayerJoin();
sendHappyMessages();
