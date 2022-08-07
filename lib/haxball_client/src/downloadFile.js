// Downloads a file in the host machine
// @param {string} filename - the name of the output file
// @param {string, uin8tArray} content - the content of the output file
function downloadFile(filename, content) {
  var element = document.createElement('a');
  var blob = new Blob([content], { type: "text/html;charset=UTF-8" });
  var url = URL.createObjectURL(blob);
  element.setAttribute('href', url);
  element.setAttribute('download', filename);
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
}

export { downloadFile };
