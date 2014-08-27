#!/bin/bash -x

current_xls=`find ../source3d -type f -name 'objectTree*' | sort -n | tail -n 1`
current_dir=`find ../source3d -type d -name 'models*' | sort -n | tail -n 1`

cp "$current_xls" "../db/excel/units.xls"

cp -R "$current_dir"/* "../public/models/"
