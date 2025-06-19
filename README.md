# Simple Web App

This project is intended to test hosting a simple web app on the devserver.

## Enter development shell

```bash
nix develop
```

Alternatively, you can use [direnv](https://direnv.net/):

```bash
direnv allow
```

## Install dependencies

```bash
npm install
```

## Running the app with vite

```bash
npm run dev     # Serves directly, no dist folder
```

## Production build with vite

```bash
npm run build     # Creates dist folder

npm run preview   # Serves the built files from dist
```

## Running the app with docker

```bash
docker build -t helloworld-test .

docker run -p 3000:80 helloworld-test
```

## Serve with Nginx on NixOS

Add this to your NixOS configuration:

```nix
# flake.nix
inputs.helloworld-test.url = "github:anonymouslearner-en/hs-helloworld-test";
```

```nix
# nginx configuration
services.nginx = {
  enable = true;
  virtualHosts = {
    "${config.networking.domain}" = {
      root = "${inputs.helloworld-test.packages.${pkgs.system}.default}/html";
    };
  };
};
```
