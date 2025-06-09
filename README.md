# Simple Web App

This project is intended to test hosting a simple web app on the devserver

<br>

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
