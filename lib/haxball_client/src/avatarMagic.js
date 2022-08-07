import { room } from "./room";
import { randomInt } from "./utils";
import { e } from "./emojis";

var timeouts = {};
function handleAvatar(player, emojis) {
  clearTimeout(timeouts[player.id]);

  room.setPlayerAvatar(player.id, e(emojis[randomInt(emojis.length)]));

  timeouts[player.id] = setTimeout(() => {
    room.setPlayerAvatar(player.id, null);
  }, 1000);
}

var qEmojis = ["faceWithMonocle", "faceWithRaisedEyebrow", "thinkingFace"];
function handleQ(player) {
  handleAvatar(player, qEmojis);
}

var ezEmojis = ["smilingFaceWithSunglasses", "yawningFace"];
function handleEz(player) {
  handleAvatar(player, ezEmojis);
}

var sryEmojis = ["pleadingFace"];
function handleSry(player) {
  handleAvatar(player, sryEmojis);
}

export { handleQ, handleEz, handleSry};
