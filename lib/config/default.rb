# Default configuration file defines default set of units and conversions
# to be used by concrete Calculator instances.

Quantity::configure do |config|

  # Electrical Units
  config.unit :unit => :A
  config.unit :unit => :mA, :based_on => :A, :coefficient => 0.001
  config.unit :unit => :mkA, :based_on => :A, :coefficient => 0.000001
  config.unit :unit => :kA, :based_on => :A, :coefficient => 1000
  config.unit :unit => :C
  config.unit :unit => :mC, :based_on => :C, :coefficient => 0.001
  config.unit :unit => :mkC, :based_on => :C, :coefficient => 0.000001
  config.unit :unit => :kC, :based_on => :C, :coefficient => 1000
  config.unit :unit => :V
  config.unit :unit => :mV, :based_on => :V, :coefficient => 0.001
  config.unit :unit => :mkV, :based_on => :V, :coefficient => 0.000001
  config.unit :unit => :kV, :based_on => :V, :coefficient => 1000
  config.unit :unit => :Ohm
  config.unit :unit => :mOhm, :based_on => :Ohm, :coefficient => 0.001
  config.unit :unit => :mkOhm, :based_on => :Ohm, :coefficient => 0.000001
  config.unit :unit => :kOhm, :based_on => :Ohm, :coefficient => 1000
  config.unit :unit => :S
  config.unit :unit => :mS, :based_on => :S, :coefficient => 0.001
  config.unit :unit => :mkS, :based_on => :S, :coefficient => 0.000001
  config.unit :unit => :kS, :based_on => :S, :coefficient => 1000
  config.unit :unit => :F
  config.unit :unit => :mF, :based_on => :F, :coefficient => 0.001
  config.unit :unit => :mkF, :based_on => :F, :coefficient => 0.000001
  config.unit :unit => :H
  config.unit :unit => :mH, :based_on => :H, :coefficient => 0.001
  config.unit :unit => :mkH, :based_on => :H, :coefficient => 0.000001
  config.unit :unit => :kH, :based_on => :H, :coefficient => 1000
  config.unit :unit => :J
  config.unit :unit => :mJ, :based_on => :J, :coefficient => 0.001
  config.unit :unit => :mkJ, :based_on => :J, :coefficient => 0.000001
  config.unit :unit => :kJ, :based_on => :J, :coefficient => 1000
  config.unit :unit => :W
  config.unit :unit => :kW, :based_on => :W, :coefficient => 1000
  config.unit :unit => :kWh
  config.unit :unit => :Hz
  config.unit :unit => :mHz, :based_on => :Hz, :coefficient => 0.001
  config.unit :unit => :mkHz, :based_on => :Hz, :coefficient => 0.000001
  config.unit :unit => :kHz, :based_on => :Hz, :coefficient => 1000
  config.unit :unit => :rad

  #	Units of Length  
  config.unit :unit => :mm
  config.unit :unit => :cm, :based_on => :mm, :coefficient => 10
  config.unit :unit => :dm, :based_on => :cm, :coefficient => 10
  config.unit :unit => :m, :based_on => :cm, :coefficient => 100
  config.unit :unit => :km, :based_on => :m, :coefficient => 1000
  config.unit :unit => :in, :based_on => :cm, :coefficient => 2.54
  config.unit :unit => :ft, :based_on => :in, :coefficient => 12
  config.unit :unit => :yd, :based_on => :ft, :coefficient => 3
  config.unit :unit => :mi, :based_on => :yd, :coefficient => 1760
  config.unit :unit => :rd, :based_on => :in, :coefficient => 198

  #	Units of Mass -->
  config.unit :unit => :g
  config.unit :unit => :kg, :based_on => :g, :coefficient => 1000
  config.unit :unit => :oz, :based_on => :g, :coefficient => 28.349523125
  config.unit :unit => :lb, :based_on => :oz, :coefficient => 16
  config.unit :unit => :mg, :based_on => :g, :coefficient => 0.001
  
  #	Units of Capacity or Volume -->
  config.unit :unit => :L
  config.unit :unit => :mL, :based_on => :L, :coefficient => 0.001
  config.unit :unit => :cu_dm, :based_on => :L, :coefficient => 1
  config.unit :unit => :cu_cm, :based_on => :L, :coefficient => 0.001
  config.unit :unit => :cu_in, :based_on => :L, :coefficient => 0.016387064
  config.unit :unit => :cu_ft, :based_on => :cu_in, :coefficient => 1728
  config.unit :unit => :cu_yd, :based_on => :cu_ft, :coefficient => 27
  config.unit :unit => :cu_mm, :based_on => :cu_cm, :coefficient => 0.001
  config.unit :unit => :cu_m, :based_on => :L, :coefficient => 1000
  config.unit :unit => :gal, :based_on => :L, :coefficient => 3.785332
  config.unit :unit => :qt, :based_on => :gal, :coefficient => 0.25
  
  #	Units of time  -->
  config.unit :unit => :sec
  config.unit :unit => :min, :based_on => :sec, :coefficient => 60
  config.unit :unit => :hour, :based_on => :min, :coefficient => 60
  config.unit :unit => :day, :based_on => :hour, :coefficient => 24
  
  # Units of Area -->
  config.unit :unit => :sq_mm
  config.unit :unit => :sq_cm, :based_on => :sq_mm, :coefficient => 100
  config.unit :unit => :sq_m, :based_on => :sq_cm, :coefficient => 10000
  config.unit :unit => :ha, :based_on => :sq_m, :coefficient => 10000
  config.unit :unit => :sq_in, :based_on => :sq_cm, :coefficient => 6.4516
  config.unit :unit => :sq_ft, :based_on => :sq_in, :coefficient => 144
  config.unit :unit => :acre, :based_on => :sq_ft, :coefficient => 43560
  #	Units of Preassure  -->
  config.unit :unit => :Pa
  config.unit :unit => :bar, :based_on => :Pa, :coefficient => 100000
  config.unit :unit => :kPa, :based_on => :Pa, :coefficient => 1000
  config.unit :unit => :hPa, :based_on => :Pa, :coefficient => 100
  config.unit :unit => :mbar, :based_on => :hPa, :coefficient => 1
  config.unit :unit => :atm, :based_on => :Pa, :coefficient => 101325
  config.unit :unit => :mm_Hg
  
  #Define conversions
  
  config.conversion 1.sq_mm => 1.mm * 1.mm
  config.conversion 1.cu_mm => 1.mm * 1.mm * 1.mm
  config.conversion 1.Hz  => 1 / 1.sec

  config.conversion 1.C => 1.F * 1.V
  config.conversion 1.W => 1.A * 1.V
  config.conversion 1.V => 1.A * 1.Ohm  
  config.conversion 1.W => 1.J / 1.sec
  config.conversion 1.Hz => 6.28318530718.rad / 1.sec
  config.conversion 1.Pa => 0.000145038.lb / 1.sq_in 
  
end