# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir E:/GIT/COL216-Coursework/arm_processor/project_vivado/final/final.cache/wt [current_project]
set_property parent.project_path E:/GIT/COL216-Coursework/arm_processor/project_vivado/final/final.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo e:/GIT/COL216-Coursework/arm_processor/project_vivado/final/final.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files {{E:/Me/IIT/Sem 4/COL216/Lab/bram_data.coe}}
read_vhdl -library xil_defaultlib {
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/Actrl.vhd}
  E:/GIT/COL216-Coursework/arm_processor/project_vivado/final/final.srcs/sources_1/imports/hdl/BRAM_wrapper.vhd
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/Bctrl.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/alu.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/package.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/controller.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/controller_states.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/register.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/multiplier.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/shifter.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/data_path.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/decoder.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/seven_seg.vhd}
  {E:/Me/IIT/Sem 4/COL216/Lab/LAB4_FINAL_SRCS/arm_processor/processor.vhd}
}
add_files E:/GIT/COL216-Coursework/arm_processor/project_vivado/final/final.srcs/sources_1/bd/BRAM/BRAM.bd
set_property used_in_implementation false [get_files -all e:/GIT/COL216-Coursework/arm_processor/project_vivado/final/final.srcs/sources_1/bd/BRAM/ip/BRAM_blk_mem_gen_0_0/BRAM_blk_mem_gen_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all E:/GIT/COL216-Coursework/arm_processor/project_vivado/final/final.srcs/sources_1/bd/BRAM/BRAM_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/ansh/Downloads/Processor.xdc
set_property used_in_implementation false [get_files C:/Users/ansh/Downloads/Processor.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top processor -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef processor.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file processor_utilization_synth.rpt -pb processor_utilization_synth.pb"
