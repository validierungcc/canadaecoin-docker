**Deutsche eMark**

https://github.com/validierungcc/eMark-docker

https://canadaecoin.site/


Example docker-compose.yml

     ---
    version: '3.9'
    services:
        emark:
            container_name: canada-ecoin
            image: vfvalidierung/deutsche_emark
            restart: unless-stopped
            user: 1000:1000
            ports:
                - '4555:4555'
                - '127.0.0.1:4444:4444'
            volumes:
                - 'emark:/ecoin/.canadaecoin'
    volumes:
       emark:

**RPC Access**

    curl --user '<user>:<password>' --data-binary '{"jsonrpc":"2.0","id":"curltext","method":"getinfo","params":[]}' -H "Content-Type: application/json" http://127.0.0.1:4444
