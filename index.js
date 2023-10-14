const Moralis = require("moralis").default;
const fs = require("fs");
require("dotenv").config();

const fileUploads = [
  {
    path: "smart.js",
    content: fs.readFileSync("./smart.js", { encoding: "base64" }),
  },
];

async function uploadToIpfs() {
  await Moralis.start({
    apiKey: process.env.MORALIS_KEY,
  });

  const res = await Moralis.EvmApi.ipfs.uploadFolder({
    abi: fileUploads,
  });

  console.log(res.result);
}

uploadToIpfs();
