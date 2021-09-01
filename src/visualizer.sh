#!/bin/bash -e

echo "Waiting for server..."
npx wait-on http://localhost:3430

echo "Visualizer server is up!"
exec chromium --no-sandbox --disable-dev-shm-usage --kiosk http://localhost:3430
