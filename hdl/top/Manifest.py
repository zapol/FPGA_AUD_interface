files = ["spec_top.vhd", 
	 "spec_top.ucf",
	 "reset_gen.vhd" ]

fetchto = "../ip_cores"

files = ["../ip_cores/urv/xurv_core.vhd", "spec_top.vhd", "reset_gen.vhd", "spec_top.ucf" ];

modules = {
    "local" : ["../ip_cores/general-cores", "../ip_cores/urv" ]
    # "local" : ["../rtl/", "../ip_cores/general-cores", "../ip_cores/urv" ]
    }
