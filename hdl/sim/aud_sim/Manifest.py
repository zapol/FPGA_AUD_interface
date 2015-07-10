action = "simulation"
sim_tool = "modelsim"
top_module = "aud_tb"

sim_post_cmd = "vsim -do run.do -i aud_tb"

modules = {
    "local" : [ "../../testbench/aud_tb" ],
}