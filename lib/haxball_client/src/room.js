import { longbounceStadium } from "./stadiums/longbounce";

var room = HBInit({
	roomName: process.env.CLIENT_NAME || "Longaniza",
	maxPlayers: Number(process.env.CLIENT_MAX_PLAYERS || 16),
	noPlayer: true,
  password: process.env.CLIENT_PASSWORD || undefined,
});

room.setCustomStadium(longbounceStadium);
room.setScoreLimit(1);
room.setTimeLimit(0);

export {room};
