let http = require("http");
let crypto = require("crypto");
let secret = "123456";
function sign(body) {
  return `sha1=` + crypto.createHmac("sha1", secret).update(body).digest("hex");
}
let server = http.createServer(function (req, res) {
  console.log(req.method, req.url);
  if (req.method === "POST" && req.url === "/webhook") {
    const buffers = [];
    req.on("data", function (buffer) {
      buffers.push(buffer);
    });
    req.on("end", function () {
      const body = Buffer.concat(buffers);
      const event = req.headers["x-github-event"];
      const signature = req.headers["x-hub-signature"];
      if (signature !== sign(body)) {
        res.end(JSON.stringify({ ok: false, message: "签名不正确" }));
        return;
      }
    });
    res.setHeader("Content-Type", "application/json");
    res.end(JSON.stringify({ ok: true }));
  } else {
    res.end("Not Found");
  }
});
server.listen(4000, function () {
  console.log("webhook服务已经在4000端口上启动");
});
