#!/bin/bash
rm -r ../docs
npm run build
mkdir ../docs
cp -r dist/* ../docs