action = "simulation"
sim_tool = "modelsim"
top_module = "btm_tb"

sim_post_cmd = "vsim -do run.do -i btm_tb"

modules = {
    "local" : [ "../../testbench/btm_tb" ],
}