import { room } from "./room";

const timeoutRegistry = {};
const maxTime = 15000;

function startLoginTimeout(player) {
  var timeout = setTimeout(function() {
    room.kickPlayer(player.id, "Poné la contraseña kpo", false);
  }, maxTime);

  timeoutRegistry[player.id] = timeout;
}

function login(player, password) {
  var myHeaders = new Headers();
  myHeaders.append("Accept", "application/json;version=2");

  var formdata = new FormData();
  formdata.append("auth[name]", player.name);
  formdata.append("auth[password]", password);

  var requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: formdata
  };

  var endpoint = process.env.BASE_API_URL + "/players/auth";

  fetch(endpoint, requestOptions)
    .then(response => {
      console.log(response.status);
      if (response.status === 200) {
        clearTimeout(timeoutRegistry[player.id]);
        timeoutRegistry[player.id] = null;
        room.sendAnnouncement("Login correcto", player.id);
      } else if (response.status === 404) {
        room.sendAnnouncement("No existe tu usuario", player.id);
      } else {
        room.sendAnnouncement("Contraseña incorrecta", player.id);
      }
    })
    .catch(error => console.log('error', error));
}

export { login, startLoginTimeout };
