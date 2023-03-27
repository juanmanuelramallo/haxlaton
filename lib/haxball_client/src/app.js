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
import { chatLog } from "./chatLog";

room.onGameTick = function() {
  storePlayerPositions();
  setTeamPlayers();
}

room.onPlayerChat = function(player, message) {
  if (chatLog.enabled && getGameStatus() != STOPPED) {
    chatLog.log(player, message);
  }

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
  chatLog.clear();
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
