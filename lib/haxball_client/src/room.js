import { longbounceStadium } from "./stadiums/longbounce";

var room = HBInit({
	roomName: "Longaniza",
	maxPlayers: 16,
	noPlayer: true
});

room.setCustomStadium(longbounceStadium);
room.setScoreLimit(1);
room.setTimeLimit(0);

export {room};
