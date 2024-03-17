local rule_scarlett_solo_device = {
	matches = { { { "device.name", "equals", "alsa_card.usb-Focusrite_Scarlett_Solo_USB_Y7E3FPF1B27EC5-00" } } },
	apply_properties = {
		["device.description"] = "Scarlett Solo",
		["device.nick"] = "Scarlett Solo",
	},
}

local rule_scarlett_4i4_device = {
	matches = {
		{ { "device.name", "equals", "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D89H0MW1B21BEF-00" } },
		{ { "device.name", "equals", "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8NFB4Q1B2270D-00" } },
	},
	apply_properties = {
		["device.description"] = "Scarlett 4i4",
		["device.nick"] = "Scarlett 4i4",
	},
}

local rule_dx5_device = {
	matches = {
		{ { "device.name", "equals", "alsa_card.usb-Topping_DX5-00" } },
		{ { "device.name", "equals", "alsa_card.usb-Topping_DX5-00.3" } },
	},
	apply_properties = {
		["device.description"] = "Topping DX5",
		["device.nick"] = "Topping DX5",
	},
}

local rule_dx5_sink = {
	matches = {
		{
			{ "node.name", "equals", "alsa_output.usb-Topping_DX5-00.analog-stereo" },
			{ "media.class", "equals", "Audio/Sink" },
		},
		{
			{ "node.name", "equals", "alsa_output.usb-Topping_DX5-00.3.analog-stereo" },
			{ "media.class", "equals", "Audio/Sink" },
		},
		{
			{ "node.name", "equals", "alsa_output.usb-Topping_DX5-00.HiFi__hw_DX5_0__sink" },
			{ "media.class", "equals", "Audio/Sink" },
		},
	},
	apply_properties = {
		["node.description"] = "Topping DX5 Output",
		["node.nick"] = "Topping DX5 Output",
	},
}

local rule_scarlett_solo_source = {
	matches = {
		{
			{ "node.name", "equals", "alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7E3FPF1B27EC5-00.analog-stereo" },
			{ "media.class", "equals", "Audio/Source" },
		},
	},
	apply_properties = {
		["node.description"] = "Scarlett Solo Input",
		["node.nick"] = "Scarlett Solo Input",
	},
}

local rule_scarlett_solo_sink = {
	matches = {
		{
			{ "node.name", "equals", "alsa_output.usb-Focusrite_Scarlett_Solo_USB_Y7E3FPF1B27EC5-00.analog-stereo" },
			{ "media.class", "equals", "Audio/Sink" },
		},
	},
	apply_properties = {
		["node.description"] = "Scarlett Solo Output",
		["node.nick"] = "Scarlett Solo Output",
	},
}

local rule_scarlett_4i4_source = {
	matches = {
		{
			{ "node.name", "equals", "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D89H0MW1B21BEF-00.analog-surround-41" },
			{ "media.class", "equals", "Audio/Source" },
		},
		{
			{ "node.name", "equals", "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D89H0MW1B21BEF-00.pro-input-0" },
			{ "media.class", "equals", "Audio/Source" },
		},
		{
			{ "node.name", "equals", "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8NFB4Q1B2270D-00.pro-input-0" },
			{ "media.class", "equals", "Audio/Source" },
		},
	},
	apply_properties = {
		["node.description"] = "Scarlett 4i4 Input",
		["node.nick"] = "Scarlett 4i4 Input",
		-- ["api.alsa.headroom"] = 1024 - 128,
	},
}

local rule_scarlett_4i4_sink = {
	matches = {
		{
			{
				"node.name",
				"equals",
				"alsa_output.usb-Focusrite_Scarlett_4i4_USB_D89H0MW1B21BEF-00.analog-surround-40",
			},
			{ "media.class", "equals", "Audio/Sink" },
		},
		{
			{ "node.name", "equals", "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D89H0MW1B21BEF-00.pro-output-0" },
			{ "media.class", "equals", "Audio/Sink" },
		},
		{
			{ "node.name", "equals", "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8NFB4Q1B2270D-00.pro-output-0" },
			{ "media.class", "equals", "Audio/Sink" },
		},
	},
	apply_properties = {
		["node.description"] = "Scarlett 4i4 Output",
		["node.nick"] = "Scarlett 4i4 Output",
		-- ["api.alsa.headroom"] = 1024 - 128,
	},
}

local rule_fiio_device = {
	matches = { { { "device.name", "equals", "alsa_card.usb-FiiO_DigiHug_USB_Audio-01" } } },
	apply_properties = {
		["node.description"] = "Fiio E10K",
		["node.nick"] = "Fiio E10K",
	},
}

local rule_fiio_sink = {
	matches = {
		{
			{ "node.name", "equals", "alsa_output.usb-FiiO_DigiHug_USB_Audio-01.analog-stereo" },
			{ "media.class", "equals", "Audio/Sink" },
		},
	},
	apply_properties = {
		["node.description"] = "Fiio E10K Output",
		["node.nick"] = "Fiio E10K Output",
	},
}

local rule_hdmi_sink = {
	matches = {
		{
			{ "node.name", "equals", "alsa_output.pci-0000_01_00.1.hdmi-stereo" },
			{ "media.class", "equals", "Audio/Sink" },
		},
	},
	apply_properties = {
		["node.description"] = "HDMI Output",
		["node.nick"] = "HDMI Output",
	},
}

local rule_disable_devices = {
	matches = {
		{
			{
				"device.name",
				"equals",
				"alsa_card.usb-SHENZHEN_AONI_ELECTRONIC_CO.__LTD_NexiGo_N930AF_FHD_Webcam_20201217010-02",
			},
		},
		{
			{
				"device.name",
				"equals",
				"alsa_input.usb-SHENZHEN_AONI_ELECTRONIC_CO.__LTD_NexiGo_N930AF_FHD_Webcam_20201217010-02.2.mono-fallback",
			},
		},
		{
			{
				"device.name",
				"equals",
				"alsa_input.usb-SHENZHEN_AONI_ELECTRONIC_CO.__LTD_NexiGo_N930AF_FHD_Webcam_20201217010-02.mono-fallback",
			},
		},
		{
			-- Motherboard back audio
			{ "device.name", "equals", "alsa_card.usb-Generic_USB_Audio-00" },
		},
		{
			-- Graphics card HDMI
			{ "device.name", "equals", "alsa_card.pci-0000_01_00.1" },
		},
	},
	apply_properties = { ["device.disabled"] = true },
}

table.insert(alsa_monitor.rules, rule_dx5_device)
table.insert(alsa_monitor.rules, rule_dx5_sink)
table.insert(alsa_monitor.rules, rule_scarlett_solo_device)
table.insert(alsa_monitor.rules, rule_scarlett_solo_source)
table.insert(alsa_monitor.rules, rule_scarlett_solo_sink)
table.insert(alsa_monitor.rules, rule_scarlett_4i4_device)
table.insert(alsa_monitor.rules, rule_scarlett_4i4_source)
table.insert(alsa_monitor.rules, rule_scarlett_4i4_sink)
table.insert(alsa_monitor.rules, rule_fiio_device)
table.insert(alsa_monitor.rules, rule_fiio_sink)
table.insert(alsa_monitor.rules, rule_hdmi_sink)
table.insert(alsa_monitor.rules, rule_disable_devices)
