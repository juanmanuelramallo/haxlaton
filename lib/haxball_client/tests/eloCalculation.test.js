import { calculateNewEloDelta } from '../src/eloCalculation';

let teamA = [
  {
    name: 'kevo locurita',
  },
  {
    name: 'El Bicho',
  },
];

let teamB = [
  {
    name: 'pete god',
  },
  {
    name: 'esviernes.com',
  },
];

const personalScoreboardCopy = {
  'kevo locurita': {
    elo: 1626,
  },
  'El Bicho': {
    elo: 1528,
  },
  'pete god': {
    elo: 1432,
  },
  'esviernes.com': {
    elo: 1577,
  },
};

describe('calculateNewEloDelta', () => {
  describe('when the team has won', () => {
    it('returns positive points variation for the teamA that has won', () => {
      expect(calculateNewEloDelta(teamA, true, teamB, personalScoreboardCopy)).toBe(5);
    });
  });

  describe('when the team has lost', () => {
    it('returns negative points variation for the teamA that has lost', () => {
      expect(calculateNewEloDelta(teamA, false, teamB, personalScoreboardCopy)).toBe(-10);
    });
  });
});
