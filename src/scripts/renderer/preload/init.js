import {remote} from 'electron';
import path from 'path';

global.manifest = remote.getGlobal('manifest');
window.localStorage.setItem('debug', process.env.DEBUG);

const appPath = remote.app.getAppPath();
const {addPath} = require(path.join(appPath, 'node_modules', 'app-module-path'));

addPath(path.join(appPath, 'scripts'));
addPath(path.join(appPath, 'node_modules'));

if (global.manifest.dev) {
  require('devtron').install();
}

require('renderer/preload');