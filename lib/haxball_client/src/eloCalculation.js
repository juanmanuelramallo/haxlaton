function calculateNewEloDelta(teamPlayers, hasWon, opponentTeamPlayers, personalScoreboard) {
  const teamElo = totalTeamElo(teamPlayers, personalScoreboard);
  const opponentTeamElo = totalTeamElo(opponentTeamPlayers, personalScoreboard);

  return newEloDelta(teamElo, hasWon, opponentTeamElo);
}

function totalTeamElo(players, personalScoreboard) {
  return players.reduce(function(total, player) {
    const playerElo = personalScoreboard[player.name].elo;

    return total + playerElo;
  }, 0);
}

function newEloDelta(totalTeamElo, hasWon, totalOpponentTeamElo) {
  const k = 15;
  const finalScore = (hasWon ? 1 : 0);
  const expectedScore = 1 / (1 + 10**((totalOpponentTeamElo - totalTeamElo) / 400));

  return Math.round((finalScore - expectedScore) * k);
}

export { calculateNewEloDelta };
