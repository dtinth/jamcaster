require("make-promises-safe");

const delay = require("delay");
const axios = require("axios");
const jayson = require("jayson/promise");
const jamulusClient = new jayson.client.tcp({ host: "127.0.0.1", port: 22100 });
let currentName;

async function main() {
  const icecastMountPoint = process.env.ICECAST_MOUNT_POINT;
  const mountPointPathname = new URL(icecastMountPoint).pathname;
  const nameTemplate = process.env.JAMULUS_CLIENT_NAME || "%s";
  const statusUrl = getStatusUrl(icecastMountPoint);

  for (;;) {
    await delay(1000);
    try {
      const response = await axios.get(statusUrl);
      let {
        icestats: { source },
      } = response.data;
      if (!Array.isArray(source)) {
        source = [source].filter((x) => x);
      }

      const matchingSource = source.find((x) => {
        return new URL(x.listenurl).pathname === mountPointPathname;
      });
      if (!matchingSource) {
        console.error("[No matching source found]");
        continue;
      }

      const name = nameTemplate.replace("%s", matchingSource.listeners);
      if (name !== currentName) {
        currentName = name;
        console.log(`Updating client name to ${name}`);
        jamulusClient
          .request("jamulusclient/setName", { name })
          .then(console.log, console.error);
      }
    } catch (error) {
      console.error(error);
    } finally {
      await delay(4000);
    }
  }
}

function getStatusUrl(icecastMountPoint) {
  const url = new URL(icecastMountPoint);
  url.pathname = "/status-json.xsl";
  url.protocol = "http:";
  return url.toString();
}

main();
