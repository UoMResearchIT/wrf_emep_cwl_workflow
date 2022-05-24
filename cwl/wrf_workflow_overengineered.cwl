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
  wrfout:
    label: output files
    type:
      type: array
      items: File
    outputSource: step4_wrf/output_wrfout


steps:
  step0_rundir:
    when: $(inputs.generate_rundir)
    run: create_run_dir.cwl
    in:
      generate_rundir: generate_rundir
    out: [rundir]

  step3_real:
    run: real.cwl
    in:
      namelist: namelist
      metdir: metdir
      rundir:
        source:
          - step0_rundir/rundir
          - rundir
        pickValue: first_non_null
      cores: realcores
    out: [output_wrfinput, output_wrfbdy]
    
  step4_wrf:
    run: wrf.cwl
    in:
      namelist: namelist
      wrfinputs: step3_real/output_wrfinput
      wrfbdys: step3_real/output_wrfbdy
      rundir:
        source:
          - step0_rundir/rundir
          - rundir
        pickValue: first_non_null
      cores: wrfcores
    out: [output_wrfout]