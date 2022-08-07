const STOPPED = 0;
const STARTED = 1;
const PAUSED = 2;
var gameStatus = STOPPED;

function setGameStatus(status) {
  if (![STOPPED, STARTED, PAUSED].includes(status)) return;

  gameStatus = status;
}

function getGameStatus() {
  return gameStatus;
}

export { setGameStatus, getGameStatus, STARTED, STOPPED, PAUSED };
