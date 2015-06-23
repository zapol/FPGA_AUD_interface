action = "simulation"
sim_tool = "modelsim"
top_module = "rmm_tb"

sim_post_cmd = "vsim -do run.do -i rmm_tb"

modules = {
    "local" : [ "../../testbench/rmm_tb" ],
}