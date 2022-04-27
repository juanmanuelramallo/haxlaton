/*
 *  Records the haxball replay file into an mp4 file via puppeteer and puppeteer-screen-recorder.
 *
 *  Usage:
 *      node record.js PAGE_URL SAVE_PATH DURATION
 *
 *  PAGE_URL is the URL to record, i.e. http://www.haxball.com/replay?v=3#https://haxlaton.dokku.1ma.dev/rails/...
 *  SAVE_PATH is the local path where to save the output recording file
 *  DURATION is the number in seconds to record
 */

const puppeteer = require('puppeteer');
const { PuppeteerScreenRecorder } = require('puppeteer-screen-recorder');

const Config = {
  followNewTab: true,
  fps: 60,
  videoFrame: {
    width: 1024,
    height: 768,
  },
  aspectRatio: '4:3',
};
const Headless = true;

const pageUrl = process.argv[2];
if (pageUrl === undefined) {
  console.error('Please pass the URL to the replay. i.e. http://www.haxball.com/replay?v=3#https://...');
  process.exit(1);
}
console.log("pageUrl: " + pageUrl);

const savePath = process.argv[3];
if (savePath === undefined) {
  console.error('Please pass the save path. i.e. ./record.mp4');
  process.exit(1);
}
console.log("savePath: " + savePath);

const durationInSeconds = process.argv[4];
if (durationInSeconds === undefined) {
  console.error('Please pass the duration in seconds. i.e. 60');
  process.exit(1);
}
console.log("durationInSeconds: " + durationInSeconds);

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

(async () => {
  const browser = await puppeteer.launch({ headless: Headless });
  const page = await browser.newPage();
  await page.setViewport({
    width: Config.videoFrame.width,
    height: Config.videoFrame.height,
    deviceScaleFactor: 1,
  });
  await page.setRequestInterception(true);

  page.on('request', (request) => {
    // Block ads
    if (request.url().includes('server.cpmstar.com') || request.url().includes('www.googletagmanager.com')) {
      request.abort();
    } else {
      request.continue()
    }
  });

  const recorder = new PuppeteerScreenRecorder(page, Config);
  await page.goto(pageUrl, { waitUntil: 'networkidle0' });
  await recorder.start(savePath);
  console.log('Recording...');
  await sleep(durationInSeconds * 1000);
  console.log('Stopping...');
  await recorder.stop();
  await browser.close();
})();
