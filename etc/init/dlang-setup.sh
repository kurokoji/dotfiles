#!/bin/sh

echo ${0}

dub fetch dls
dub run --build=release dls:bootstrap
