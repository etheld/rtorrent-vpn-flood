const CONFIG = {
  baseURI: '/',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: './server/db/',
  floodServerHost: '0.0.0.0',
  floodServerPort: 3000,
  floodServerProxy: 'http://127.0.0.1',
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: '{{ default .Env.FLOOD_PASSWORD "flood" }}',
  scgi: {
    host: 'localhost',
    port: 5000,
    socket: false,
    socketPath: '/tmp/rtorrent.sock'
  },
  ssl: false,
  sslKey: '/absolute/path/to/key/',
  sslCert: '/absolute/path/to/certificate/',
  torrentClientPollInterval: 1000 * 2
};

module.exports = CONFIG;
