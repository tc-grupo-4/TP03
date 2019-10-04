* Distributed as-is, unmodified, and at no charge by
* www.spicemodel.com 
* accuracy should be verified by user
* 
* LM833 operational amplifier
*"macromodel" subcircuit
*
* connections:
*    1 -  non-inverting input
*    2 -  inverting input
*    3 -  positive power supply
*    4 -  negative power supply
*    5 -  output
*
.subckt LM833/MC  1 2 3 4 5
*
  c1   11 12 3.501E-12
  c2    6  7 10.00E-12
  dc    5 53 dx
  de   54  5 dx
  dlp  90 91 dx
  dln  92 90 dx
  dp    4  3 dx
  egnd 99  0 poly(2) (3,0) (4,0) 0 .5 .5
  fb    7 99 poly(5) vb vc ve vlp vln 0 27.96E6
+ -30E6 30E6 30E6 -30E6
  ga    6  0 11 12 565.5E-6
  gcm   0  6 10 99 5.655E-9
  iss  10  4 dc 70.00E-6
  hlim 90  0 vlim 1K
  j1   11  2 10 jx
  j2   12  1 10 jx
  r2    6  9 100.0E3
  rd1   3 11 1.768E3
  rd2   3 12 1.768E3
  ro1   8  5 10
  ro2   7 99 20
  rp    3  4 29.03E3
  rss  10 99 2.857E6
  vb    9  0 dc 0
  vc    3 53 dc .9
  ve   54  4 dc .4
  vlim  7  8 dc 0
  vlp  91  0 dc 30
  vln   0 92 dc 30
.model dx D(Is=800.0E-18)
.model jx NJF(Is=150.0E-9 Beta=4.568E-3
+ Vto=-1)
.ends
* Macromodels, simulation models, or other models provided by
* ON, directly or indirectly, are not warranted by
* ON as fully representing all of the specifications and
* operating characteristics of the semiconductor product to
* which the model relates. Moreover, these models are
* furnished on an "as is" basis without support or warranty of
* any kind, either expressed or implied, regarding the use
* thereof and ON specifically disclaims all implied
* warranties of merchantability and fitness of the models for
* any purpose. ON does not assume any liability arising
* out of the application or use of the models including
* infringement of patents and copyrights nor does ON
* convey any license under its patents and copyrights or the
* rights of others. ON reserves the right to make
* changes without notice to any model.
*
* These macromodels were generated using the MicroSim Parts
* program.  The PSpice program derives representative circuit
* elements for the op amp macromodel from given device
* characterization information. They are appropriate for
* modeling the following parameters at 25øC:
*
* ù Positive and Negative Slew Rate
* ù Quiescent Power Dissipation
* ù Maximum Positive and Negative
*    Output Voltage Swing
* ù Input Bias Current
* ù Open Loop Voltage Gain
* ù Unity Gain Frequency
* ù Common Mode Rejection Ratio
*    (CMRR)
* ù Output Impedence (ac and dc)
* ù Output Short Circuit Current Limit
*
*  These models may not fully represent the external circuit
* effects on stability and/or phase margin. Since they are
* macromodels and not actual circuit netlists, they are
* intended to model specific device parameters at 25øC only.
*
* Although macromodels can be a useful tool in evaluating
* device performance in various applications, they cannot
* model exact device performance under all conditions, nor are
* they intended to replace breadboarding for final
* verification.
*
* These macromodels each represent one operational amplifer
* only. For a dual, use two macromodels.  For a quad, use
* four.