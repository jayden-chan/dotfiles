return {
	s(
		"service",
		fmt(
			[[
service: {1}

updatable:
	- {1}

nginx:
	template: sso-proxy
	subdomain: {1}
	name: {1}
	endpoint: http://localhost
	users: ['jayden']
	port: "{{{{ PORT_{2} }}}}"

docker:
	version: "2.1"

	services:
		{3}
]],
			{ i(1), f(function(args)
				return args[1][1]:upper()
			end, { 1 }), i(0) },
			{ repeat_duplicates = true }
		)
	),
}
