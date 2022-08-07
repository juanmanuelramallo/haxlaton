/*
 *  @param max {number} - the maximum number, exclusive
 *  @return {number} - a random number between 0 and (max - 1)
 */
function randomInt(max) {
  return Math.floor(Math.random() * max);
}

/* Removes dots, emojis and other non-alphanumeric characters from a string.
 *
 * @param name {string} - The string to sanitize
 * @return {string} - The sanitized string. Returns "sanitized" if the output is empty after the sanitization. */
function sanitize(name) {
  var sanitized = name.replace(/[^a-zA-Z0-9]/g, '');

  if (sanitized.length === 0) {
    return 'sanitized';
  }

  return sanitized;
}

export { randomInt, sanitize }
