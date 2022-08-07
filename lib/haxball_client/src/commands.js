import { room } from './room';
import { showScoreboard, downloadScoreboard, pauseScoreboard } from './scoreboard';
import { restorePosition } from './restorePosition';
import { e } from './emojis';
import { longbounceStadium } from './stadiums/longbounce';
import { longbounce3v3 } from './stadiums/longbounce3v3';
import { volleyStadium } from './stadiums/volley';
import { futsalStadium } from './stadiums/futsal';
import { playersEloInJsonFormat } from "./playersElo";
import { downloadFile } from "./downloadFile";
import { randomInt } from './utils';
import { SPECTATORS, RED_TEAM, BLUE_TEAM } from './teams';
import { login } from './login';

// Swaps the player from one team to the other
function swapPlayers() {
  room.getPlayerList().forEach(function(player) {
    if (player.team == SPECTATORS) return;

    // y = mx + b --> equation of a straight line
    // y = -x + b --> with b=3 (x,y) = (1,2) (2,1)
    room.setPlayerTeam(player.id, -player.team + 3)
  });
}

var commands = {
  "!help": {
    description: "Aiudaaaa",
    func: function(player) { showHelp() }
  },
  "!rr": {
    description: "Quien fue el pajero que tiro el teclado?",
    func: function(player) {
      room.sendAnnouncement(e("redExclamationMark") + "Reset pedido por " + player.name, null);
      room.stopGame();
      room.startGame();
    },
  },
  "!swap": {
    description: "Pa cambiar equipos",
    func: function(player) {
      room.sendAnnouncement(e("redExclamationMark") + "Swap pedido por " + player.name, null);
      swapPlayers();
    }
  },
  "!sc": {
    description: "Give me the stats daddy",
    func: function(player) { showScoreboard() }
  },
  "!psc": {
    description: "Pausar el scoreboard",
    func: function(player) {
      pauseScoreboard(true);
      room.sendAnnouncement(e("redExclamationMark") + "Scoreboard pausado por " + player.name);
    }
  },
  "!usc": {
    description: "Resumir el conteo en el scoreboard",
    func: function(player) {
      pauseScoreboard(false);
      room.sendAnnouncement(e("redExclamationMark") + "Scoreboard resumido por " + player.name);
    }
  },
  "!ds": {
    description: "Descarga el scoreboard en csv",
    func: function(player) { downloadScoreboard() }
  },
  "!de": {
    description: 'Descarga ELO de los jugadores (formato JSON)',
    func: async function(_player) {
      room.sendAnnouncement('Descargando el ELO de estos perros (JSON format)');

      const fileContent = await playersEloInJsonFormat();
      downloadFile('scoreboard.json', fileContent);
    }
  },
  "!restore": {
    description: "Si te desconectas en medio de una partida, podes correr !restore para volver a donde estabas",
    func: function(player) { restorePosition(player) }
  },
  "!volley": {
    description: "Sale beach volley",
    func: function (player) {
      room.sendAnnouncement(e("redExclamationMark") + "Volley pedido por " + player.name, null);
      room.setCustomStadium(volleyStadium)
    }
  },
  "!futsal": {
    description: "Sale futsal",
    func: function (player) {
      room.sendAnnouncement(e("redExclamationMark") + "Futsal pedido por " + player.name, null);
      room.setCustomStadium(futsalStadium)
    }
  },
  "!3v3": {
    description: "Sale ese 3v3. Todos alaben al bicho (NO GUARDA STATS)",
    func: function(player) {
      room.sendAnnouncement(`Alabado sea el Bicho ${e("bug")}  ${e("pray")}${e("prayerBeads")}`)
      room.setCustomStadium(longbounce3v3)
    }
  },
  "!2v2": {
    description: "Sale ese 2v2",
    func: function(player) { room.setCustomStadium(longbounceStadium) }
  },
  "!rand": {
    description: "Elegir jugadores random",
    func: function(player) {
      room.sendAnnouncement(`${e("redExclamationMark")} ${player.name} tiro rand`);
      assignPlayersRandomly()
    }
  },
  "!login": {
    description: "Login",
    func: function(player, args) {
      login(player, args[0]);
      return false;
    }
  }
}

async function assignPlayersRandomly() {
  let availablePlayers = getPlayersForTeam(SPECTATORS)

  if (!availablePlayers.length) { return }

  let redPlayers = getPlayersForTeam(RED_TEAM)
  let bluePlayers = getPlayersForTeam(BLUE_TEAM)

  const areTeamsBalanced = redPlayers.length === bluePlayers.length
  const multipleSpectators = availablePlayers.length > 1
  const teamSizeDifference = Math.abs(redPlayers.length - bluePlayers.length)

  if (areTeamsBalanced && !multipleSpectators) { return }

  let iterations =  2

  if (!areTeamsBalanced) {
    iterations = availablePlayers.length >= teamSizeDifference ? teamSizeDifference : 1
  }

  let redTeamSize = redPlayers.length
  let blueTeamSize = bluePlayers.length

  for (let i = 0; i < iterations; i++) {
    const selectedPlayer = availablePlayers[randomInt(availablePlayers.length)]
    const destinationTeam = redTeamSize > blueTeamSize ? BLUE_TEAM : RED_TEAM
    await room.setPlayerTeam(selectedPlayer.id, destinationTeam)

    if (destinationTeam === RED_TEAM) {
      redTeamSize++
    } else {
      blueTeamSize++
    }

    availablePlayers = getPlayersForTeam(SPECTATORS)
  }
}

function getPlayersForTeam(team) {
  return room.getPlayerList().filter(player => player.team === team)
}

function showHelp() {
  var msg = e("informationDeskWoman") + "\n";
  Object.keys(commands).forEach(function(command) {
    var meta = commands[command];
    msg += e("smallBlueDiamond") + " " + command + ": " + meta.description + "\n";
  });
  room.sendAnnouncement(msg);
}

function handleCommandsFromChat(player, message) {
  if (message[0] != "!") return;

  var commandArgs = message.split(' ');

  var command = commands[commandArgs.shift()];
  if (command) {
    return command.func.call(this, player, commandArgs);
  } else {
    room.sendAnnouncement(e("thinkingFace") + " Como que no te entiendahm");
    return true;
  }
}

export { handleCommandsFromChat };
