const { build } = require('esbuild')
const define = {}

const outfileName = process.env.OUTFILE_NAME;
const baseApiUrl = process.env.BASE_API_URL;
if (outfileName === undefined) {
  console.error('Please specify an OUTFILE_NAME');
  process.exit(1);
} else if (baseApiUrl === undefined) {
  console.error('Please specify a BASE_API_URL');
  process.exit(1);
} else {
  console.log(`Building in ${outfileName} using ${baseApiUrl}`);
}

for (const k in process.env) {
  define[`process.env.${k}`] = JSON.stringify(process.env[k])
}

const options = {
  entryPoints: ['./src/app.js'],
  outfile: `${outfileName}`,
  bundle: true,
  define,
}

build(options).catch(() => process.exit(1))
