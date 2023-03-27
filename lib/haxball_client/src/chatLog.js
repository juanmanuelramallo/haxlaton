import { room } from "./room";

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
// Does not log command messages
function log(player, message) {
  if (message.length <= 1 || message.startsWith('!'))
    return false;

  internalLog.push({ player_name: player.name, body: message, epoch_ms: Date.now() });
}

function clear() {
  console.log("Clearing chat log with " + internalLog.length + " messages");
  internalLog = [];
}

function enable() {
  console.log("Enabling chat log");
  chatLog.enabled = true;
}

function disable() {
  console.log("Disabling chat log");
  chatLog.enabled = false;
}

function persist(matchId) {
  if (!chatLog.enabled) {
    console.warn("Chat log is disabled");
    return false;
  }

  if (internalLog.length === 0) {
    console.warn("No messages to persist");
    return false;
  }

  if (!matchId) {
    console.error("No matchId provided to persist chat log");
    return false;
  }

  console.log("Persisting chat log with " + internalLog.length + " messages");
  let endpoint = process.env.BASE_API_URL + "/matches/" + matchId + "/messages";
  fetch(endpoint, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ messages: internalLog }),
    redirect: "follow"
  }).then(response => response.json())
    .then(result => {
      console.log(result);
      room.sendAnnouncement("Chat log persisted. " + result.messages_created + " messages created.");
      clear();
      return result;
    })
    .catch(error => {
      console.error("Error persisting chat log", error);
      return error;
    });
}

export { chatLog };
