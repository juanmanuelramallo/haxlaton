var emojis = {
  "bug": 128027,
  "faceWithMonocle": 129488,
  "faceWithRaisedEyebrow": 129320,
  "faceWithRollingEyes": 128580,
  "faceWithSymbolsOverMouth": 129324,
  "informationDeskWoman": 128129,
  "pleadingFace": 129402,
  "pray": 128591,
  "prayerBeads": 128255,
  "redExclamationMark": 10071,
  "smallBlueDiamond": 128313,
  "smilingFaceWithSunglasses": 128526,
  "thinkingFace": 129300,
  "yawningFace": 129393,
}
function e(emoji) {
  return String.fromCodePoint(emojis[emoji]);
}

export { e };
