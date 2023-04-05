cwlVersion: v1.2
class: Workflow

requirements:
  InlineJavascriptRequirement: {}
  MultipleInputFeatureRequirement: {}


inputs:
  namelist:
    label: Configuration File
    type: File
  metdir:
    label: Meteorological Files
    type: Directory
  rundir:
    label: Running Directory
    type: Directory
  realcores: int
  wrfcores: int
  generate_rundir: boolean
    
    
outputs:
  wrflogs:
    label: wrf logfiles
    type:
      type: array
      items: File
    outputSource: step4_wrf/output_logs
  wrfout:
    label: output files
    type:
      type: array
      items: File
    outputSource: step4_wrf/output_wrfout


steps:
  step0_rundir:
    run: create_run_dir.cwl
    in:
      generate_rundir: generate_rundir
    out: [rundir]

  step3_real:
    run: real.cwl
    in:
      namelist: namelist
      metdir: metdir
      rundir: step0_rundir/rundir
      cores: realcores
    out: [output_wrfinput, output_wrfbdy, output_logs]
    
  step4_wrf:
    run: wrf.cwl
    in:
      namelist: namelist
      wrfinputs: step3_real/output_wrfinput
      wrfbdys: step3_real/output_wrfbdy
      rundir: step0_rundir/rundir
      cores: wrfcores
    out: [output_wrfout, output_logs]