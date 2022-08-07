import { room } from "./room";
import { randomInt } from "./utils";

const happyMessagesList = [
  "JUGAS MEJOR QUE MANANA",
  "RETIRATE",
  "AVERIGUASTE DE QUE JUGAS",
  "TENES LAG EN EL CEREBRO",
  "HACE ALGO",
  "CORRETE QUE ESTAN JUGANDO",
  "JUGAS COMO UN PERRO",
  "TE LLAMAN A COMER",
  "PASATE A NAFTA",
  "TAS JUGANDO CON EL FRENO DE MANO PUESTO"
]

const announcementMessagesList = [
  "TODOS SALUDEN A",
  "BIENVENIDO",
  "MIREN A",
  "TODOS CONTRA LA PARED, LLEGO",
  "SE SUSPENDE TODO, VINO",
  "VACA YENDO GENTE AL BAILE DIJO",
  "QUIEN LE PASO EL LINK A",
  "SEGURO QUE QUERES JUGAR"
];


const happyMessages = () => {
  var players = room.getPlayerList();
  var playerList = players.filter((player) => player.position !== null);
  if (playerList.length > 0) {
    var message = playerList[randomInt(playerList.length)].name.toUpperCase() + " " + happyMessagesList[randomInt(happyMessagesList.length)];
    room.sendAnnouncement(message, null, 0x0080ff, 'bold', 0);
  }
}

function sendHappyMessages() {
  setInterval(happyMessages, 60000);
}

const announcementMessages = (playerName) => {
    room.sendAnnouncement(announcementMessagesList[randomInt(announcementMessagesList.length)] + " " + "✨" + playerName + "✨",
        null, 0x00FF00, 'bold', 2);
}

export { sendHappyMessages,  announcementMessages};
