import { playerNameUniqueness } from '../src/playerNameUniqueness';
import { room } from '../src/room';
jest.mock('../src/room', () => {
  return {
    room: {
      getPlayerList: jest.fn(),
      kickPlayer: jest.fn(),
    }
  }
})

describe('playerNameUniqueness', () => {
  it('should return true if the name is unique', () => {

    room.getPlayerList.mockReturnValue([
      { name: 'player1' },
      { name: 'player2' },
      { name: 'player3' },
      { name: 'test' } // playerName is already present in getPlayerList when checking for uniqueness
    ]);
    expect(playerNameUniqueness({ name: 'test' })).toBe(true);
  });

  it('should return false if the name is not unique', () => {
    room.getPlayerList.mockReturnValue([
      { name: 'player1' },
      { name: 'player2' },
      { name: 'test' },
      { name: 'test' } // simulating a player with the same name
    ]);
    expect(playerNameUniqueness({ name: 'test' })).toBe(false);
  });
});
