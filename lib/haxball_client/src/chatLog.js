// chatLog object must respond to the following methods:
// - log(player, message) - locally saves the message a player sent
// - clear() - clears all locally saved messages
// - persist() - sends all locally saved messages to the server
// - enable() - enables the log method
// - disable() - disables the log method

const chatLog = {
  clear: clear,
  disable: disable,
  enable: enable,
  enabled: false,
  log: log,
  persist: persist
};

let internalLog = [];

// Does not log one-char messages
function log(player, message) {
  if (message.length <= 1)
    return false;

  internalLog.push({ player_id: player.id, message, epoch_ms: Date.now() });
}

function clear() {
  console.log("Clearing chat log with " + internalLog.length + " messages");
  internalLog = [];
}

function enable() {
  chatLog.enabled = true;
}

function disable() {
  chatLog.enabled = false;
}

function persist(matchId) {
  console.log("persiste");
  if (!chatLog.enabled)
    return false;

  if (internalLog.length === 0)
    return false;

  console.log("Persisting chat log with " + internalLog.length + " messages");
  console.log(internalLog);
  // Send the log to the server
  // ...

  // Clear the log
  clear();
}

export { chatLog };
