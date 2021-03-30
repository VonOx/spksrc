#!/bin/sh
set +x

GetShares()
{
	for share in `sudo /usr/syno/sbin/synoshare  --enum ALL|tail -n +3`; do
		path=$(sudo /usr/syno/sbin/synoshare --get "${share}"|sed -n 's/.*Path.*\[\(.*\)\]/\1/p')
		echo "[\"$path\", \"$share (${path})\"]"
	done  | tr -s '\n' ',' | sed -e 's/,$//'
}


FIRST=`/bin/cat<<EOF
{
		"step_title": "Data location",
		"items": [{
                "desc": "The installer will download and run the latest versions of Gladys Assistant. <br/>Please fill the desired storage location for the data directory below (create a new <b>Shared Folder</b> if none of the ones below suits storage of Gladys Assistant data)."
            },{
			"type": "combobox",
			"subitems": [{
				"key": "wizard_share_path",
				"desc": "Shared Folder to store Gladys Assistant data in",
				"editable": false,
				"mode": "local",
				"value": "",
				"valueField": "path",
				"displayField": "display_name",
				"store": {
					"xtype": "arraystore",
					"fields": ["path", "display_name"],
					"data": [$(GetShares)]
				}
			}]
		}, {
			"type": "textfield",
			"subitems": [{
				"key": "wizard_folder_name",
				"desc": "Data folder name",
				"value": "gladysassistant",
				"disabled": false
			}]
		}]
	}
EOF`

echo "[$FIRST]" > $SYNOPKG_TEMP_LOGFILE

exit 0
