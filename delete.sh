sessionID="594e8ea7c6166d863f223d411e747f6d"
addr="http://localhost:53784"
curl -X DELETE \
     "${addr}/session/${sessionID}" \
     -H "Content-Type: application/json; charset=utf-8"
