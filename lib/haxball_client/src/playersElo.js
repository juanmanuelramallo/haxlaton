import { getPersonalScoreboard } from "./scoreboard";

const playersElo = async function () {
  const url = process.env.BASE_API_URL + "/players";
  let elos = {};
  await fetch(url)
    .then(data => data.json())
    .then(players => {
      players.forEach(player => {
        elos[player.name] = player.elo;
      });
    });

  return elos;
};

const playersEloInJsonFormat = function () {
  const previousElos = playersElo();
  const newElos = getPersonalScoreboard();
  const allElos = {...previousElos, ...newElos};
  const orderedElosByNickname = Object.keys(allElos).sort().reduce(
    (ordered, key) => {
      ordered[key] = allElos[key];
      return ordered;
    },
    {}
  );
  return JSON.stringify(orderedElosByNickname);
}

export {
  playersElo,
  playersEloInJsonFormat,
}
