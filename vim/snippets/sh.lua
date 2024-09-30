---@diagnostic disable: undefined-global
return {
	s("cpr", t("rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 -e ssh")),
	s("mvr", t("rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files -e ssh")),
	s(
		"argparse",
		fmt(
			[[
while test $# -gt 0
do
	case "$1" in
		--flag) echo "flag"
			;;
		*) echo "parameter"
			;;
	esac
	shift
done
]],
			{}
		)
	),
}
