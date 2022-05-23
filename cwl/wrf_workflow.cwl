cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}


inputs:
  namelist:
    label: Configuration File
    type: File
  metdir:
    label: Meteorological Files
    type: Directory
  rundir:
    label: WRF running directory
    type: Directory
  realcores: int
  wrfcores: int
    
    
outputs:
  wrfout:
    label: output files
    type:
      type: array
      items: File
    outputSource: step4_wrf/output_wrfout


steps:
  step3_real:
    run: real.cwl
    in:
      namelist: namelist
      metdir: metdir
      rundir: rundir
      cores: realcores
    out: [output_wrfinput, output_wrfbdy]
    
  step4_wrf:
    run: wrf.cwl
    in:
      namelist: namelist
      wrfinputs: step3_real/output_wrfinput
      wrfbdys: step3_real/output_wrfbdy
      rundir: rundir
      cores: wrfcores
    out: [output_wrfout]