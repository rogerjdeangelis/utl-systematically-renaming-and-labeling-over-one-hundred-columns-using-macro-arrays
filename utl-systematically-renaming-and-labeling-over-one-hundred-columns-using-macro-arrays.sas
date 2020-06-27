Systematically-renaming-and-labeling-over-one-hundred-columns-using-macro-arrays                                             
                                                                                                                             
        Method                                                                                                               
                                                                                                                             
           1. Create a SAS table with over 120 names to be renamed and labeled                                               
                                                                                                                             
           2. Create five macro arrays containing columns with common prefixes                                               
                                                                                                                             
           3. Iterate over the five arrays adding new names and labels                                                       
                                                                                                                             
           4. Example of typical names and renames and relabels                                                              
                                                                                                                             
               OLD NAME      NEW NAME            LABEL                                                                       
                                                                                                                             
              SHK_1M_SPS   SUNDAY_SHK_1M_SPS     BASKETBALL MONDAY CTI_1M_ALL                                                
              SHK_2M_SPS   SUNDAY_SHK_2M_SPS     BASKETBALL MONDAY CTI_1M_SP                                                 
              SHK_3M_SPS   SUNDAY_SHK_3M_SPS     BASKETBALL MONDAY CTI_1M_SPA                                                
                                                                                                                             
              SI_QRY_01    THURSDAY_SI_QRY_01    TRACK THURSDAYSI_QRY_01                                                     
              SI_QRY_02    THURSDAY_SI_QRY_02    TRACK THURSDAYSI_QRY_02                                                     
              SI_QRY_03    THURSDAY_SI_QRY_03    TRACK THURSDAYSI_QRY_03                                                     
                                                                                                                             
github                                                                                                                       
https://tinyurl.com/y9hsun5g                                                                                                 
https://communities.sas.com/t5/SAS-Programming/How-do-I-add-labels-to-these-variables/m-p/665384                             
                                                                                                                             
This solution requires Ted Clay's array and dO-ver macros                                                                    
  Ted Clay tclay@ashlandhome.net  (541) 482-6435                                                                             
  David Katz, M.S. www.davidkatzconsulting.com                                                                               
                                                                                                                             
For more functional macro array and do_over see                                                                              
    Bartosz Jablonski (yabwon@gmail.com)                                                                                     
    https://github.com/yabwon/SAS_PACKAGES                                                                                   
                                                                                                                             
macro utlnopts is used to reduce the log - not needed;                                                                       
                                                                                                                             
macros                                                                                                                       
https://tinyurl.com/y9nfugth                                                                                                 
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories                                   
                                                                                                                             
/*                   _                                                                                                       
(_)_ __  _ __  _   _| |_                                                                                                     
| | `_ \| `_ \| | | | __|                                                                                                    
| | | | | |_) | |_| | |_                                                                                                     
|_|_| |_| .__/ \__,_|\__|                                                                                                    
        |_|                                                                                                                  
*/                                                                                                                           
                                                                                                                             
data have;                                                                                                                   
input                                                                                                                        
SOURCECODE ACCOUNT_NUMBER SHK_1M_SPS SHK_2M_SPS SHK_3M_SPS SHK_1M_SP                                                         
SHK_2M_SP SHK_3M_SP SHK_1M_SPA SHK_2M_SPA SHK_3M_SPA SHK_1M_ALL                                                              
SHK_2M_ALL SHK_3M_ALL CTI_1M_SPS CTI_1M_SP CTI_1M_SPA CTI_1M_ALL                                                             
CTI_3M_SPS CTI_3M_SP CTI_3M_SPA CTI_3M_ALL CTI_6M_SPS CTI_6M_SP                                                              
CTI_6M_SPA CTI_6M_ALL CTD_1M_SPS CTD_1M_SP CTD_1M_SPA CTD_1M_ALL                                                             
CTD_3M_SPS CTD_3M_SP CTD_3M_SPA CTD_3M_ALL CTD_6M_SPS CTD_6M_SP                                                              
CTD_6M_SPA CTD_6M_ALL EPF_ALL_01 EPF_ALL_02 EPF_ALL_03 EPF_ALL_04                                                            
EPF_ALL_05 EPF_ALL_06 EPF_ALL_07 EPF_ALL_08 EPF_ALL_09 EPF_ALL_10                                                            
EPF_ALL_11 EPF_ALL_12 EPF_ALL_13 EPF_ALL_14 EPF_ALL_15 EPF_MG_01                                                             
EPF_MG_02 EPF_MG_03 EPF_MG_04 EPF_MG_05 EPF_MG_06 EPF_MG_07 EPF_MG_08                                                        
EPF_MG_09 EPF_MG_10 EPF_MG_11 EPF_MG_12 EPF_MG_13 EPF_MG_14 EPF_MG_15                                                        
EPF_IO_01 EPF_IO_02 EPF_IO_03 EPF_IO_04 EPF_IO_05 EPF_IO_06 EPF_IO_07                                                        
EPF_IO_08 EPF_IO_09 EPF_IO_10 EPF_IO_11 EPF_IO_12 EPF_IO_13 EPF_IO_14                                                        
EPF_IO_15 SI_ALL_01 SI_ALL_02 SI_ALL_03 SI_ALL_04 SI_ALL_05 SI_DEC_01                                                        
SI_DEC_02 SI_DEC_03 SI_PS_01 SI_PS_02 SI_PS_03 SI_DA_01 SI_DA_02                                                             
SI_DA_03 SI_GA_01 SI_GA_02 SI_GA_03 SI_REC_01 SI_REC_02 SI_REC_03                                                            
SI_VT_01 SI_VT_02 SI_VT_03 SI_ARR_01 SI_ARR_02 SI_ARR_03 SI_DM_01                                                            
SI_DM_02 SI_DM_03 SI_CIC_01 SI_CIC_02 SI_CIC_03 SI_QRY_01 SI_QRY_02                                                          
SI_QRY_03 SI_DS_01 SI_DS_02 SI_DS_03 $1. @@;                                                                                 
cards4;                                                                                                                      
                                                                                                                             
;;;;                                                                                                                         
run;quit;                                                                                                                    
                                                                                                                             
/*           _               _                                                                                               
  ___  _   _| |_ _ __  _   _| |_                                                                                             
 / _ \| | | | __| `_ \| | | | __|                                                                                            
| (_) | |_| | |_| |_) | |_| | |_                                                                                             
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                            
                |_|                                                                                                          
*/                   |                                                                                                       
                     |                                                                                                       
                     |            OUTPUT                                                                                     
      INPUT          |            ======                                                                                     
      =====          |       The CONTENTS Procedure                                                                          
                     |                                                                                                       
                     |      Variables in Creation Order                                                                      
                     |                                                                                                       
                     |                                                                                                       
                     |  RULES RENAME AND ADD A LABEL                                                                         
                     |                                                                                                       
      OLD COLUMN     |   NEW COLUMN            NEW                                                                           
  #   NAME           |   NAME                  LABEL                                                                         
                     |                                                                                                       
  1   SOURCECODE     |   SOURCECODE                                                                                          
  2   ACCOUNT_NUMBER |   ACCOUNT_NUMBER                                                                                      
  3   SHK_1M_SPS     |   SUNDAY_SHK_1M_SPS     BASKETBALL MONDAY CTI_1M_ALL                                                  
  4   SHK_2M_SPS     |   SUNDAY_SHK_2M_SPS     BASKETBALL MONDAY CTI_1M_SP                                                   
  5   SHK_3M_SPS     |   SUNDAY_SHK_3M_SPS     BASKETBALL MONDAY CTI_1M_SPA                                                  
  6   SHK_1M_SP      |   SUNDAY_SHK_1M_SP      BASKETBALL MONDAY CTI_1M_SPS                                                  
  7   SHK_2M_SP      |   SUNDAY_SHK_2M_SP      BASKETBALL MONDAY CTI_3M_ALL                                                  
  8   SHK_3M_SP      |   SUNDAY_SHK_3M_SP      BASKETBALL MONDAY CTI_3M_SP                                                   
  9   SHK_1M_SPA     |   SUNDAY_SHK_1M_SPA     BASKETBALL MONDAY CTI_3M_SPA                                                  
 10   SHK_2M_SPA     |   SUNDAY_SHK_2M_SPA     BASKETBALL MONDAY CTI_3M_SPS                                                  
 11   SHK_3M_SPA     |   SUNDAY_SHK_3M_SPA     BASKETBALL MONDAY CTI_6M_ALL                                                  
 12   SHK_1M_ALL     |   SUNDAY_SHK_1M_ALL     BASKETBALL MONDAY CTI_6M_SP                                                   
 13   SHK_2M_ALL     |   SUNDAY_SHK_2M_ALL     BASKETBALL MONDAY CTI_6M_SPA                                                  
 14   SHK_3M_ALL     |   SUNDAY_SHK_3M_ALL     BASKETBALL MONDAY CTI_6M_SPS                                                  
...                  |                                                                                                       
...                  |                                                                                                       
115   SI_CIC_03      |   THURSDAY_SI_CIC_03    TRACK THURSDAYSI_CIC_03                                                       
116   SI_QRY_01      |   THURSDAY_SI_QRY_01    TRACK THURSDAYSI_QRY_01                                                       
117   SI_QRY_02      |   THURSDAY_SI_QRY_02    TRACK THURSDAYSI_QRY_02                                                       
118   SI_QRY_03      |   THURSDAY_SI_QRY_03    TRACK THURSDAYSI_QRY_03                                                       
119   SI_DS_01       |   THURSDAY_SI_DS_01     TRACK THURSDAYSI_DS_01                                                        
120   SI_DS_02       |   THURSDAY_SI_DS_02     TRACK THURSDAYSI_DS_02                                                        
                                                                                                                             
/*                                                                                                                           
 _ __  _ __ ___   ___ ___  ___ ___                                                                                           
| `_ \| `__/ _ \ / __/ _ \/ __/ __|                                                                                          
| |_) | | | (_) | (_|  __/\__ \__ \                                                                                          
| .__/|_|  \___/ \___\___||___/___/                                                                                          
|_|                                                                                                                          
*/                                                                                                                           
                                                                                                                             
proc datasets lib=work nolist;                                                                                               
 delete have;                                                                                                                
run;quit;                                                                                                                    
                                                                                                                             
* because of the inplace rename you need to run this each time you rerun ;                                                   
                                                                                                                             
data have;                                                                                                                   
input                                                                                                                        
SOURCECODE ACCOUNT_NUMBER SHK_1M_SPS SHK_2M_SPS SHK_3M_SPS SHK_1M_SP                                                         
SHK_2M_SP SHK_3M_SP SHK_1M_SPA SHK_2M_SPA SHK_3M_SPA SHK_1M_ALL                                                              
SHK_2M_ALL SHK_3M_ALL CTI_1M_SPS CTI_1M_SP CTI_1M_SPA CTI_1M_ALL                                                             
CTI_3M_SPS CTI_3M_SP CTI_3M_SPA CTI_3M_ALL CTI_6M_SPS CTI_6M_SP                                                              
CTI_6M_SPA CTI_6M_ALL CTD_1M_SPS CTD_1M_SP CTD_1M_SPA CTD_1M_ALL                                                             
CTD_3M_SPS CTD_3M_SP CTD_3M_SPA CTD_3M_ALL CTD_6M_SPS CTD_6M_SP                                                              
CTD_6M_SPA CTD_6M_ALL EPF_ALL_01 EPF_ALL_02 EPF_ALL_03 EPF_ALL_04                                                            
EPF_ALL_05 EPF_ALL_06 EPF_ALL_07 EPF_ALL_08 EPF_ALL_09 EPF_ALL_10                                                            
EPF_ALL_11 EPF_ALL_12 EPF_ALL_13 EPF_ALL_14 EPF_ALL_15 EPF_MG_01                                                             
EPF_MG_02 EPF_MG_03 EPF_MG_04 EPF_MG_05 EPF_MG_06 EPF_MG_07 EPF_MG_08                                                        
EPF_MG_09 EPF_MG_10 EPF_MG_11 EPF_MG_12 EPF_MG_13 EPF_MG_14 EPF_MG_15                                                        
EPF_IO_01 EPF_IO_02 EPF_IO_03 EPF_IO_04 EPF_IO_05 EPF_IO_06 EPF_IO_07                                                        
EPF_IO_08 EPF_IO_09 EPF_IO_10 EPF_IO_11 EPF_IO_12 EPF_IO_13 EPF_IO_14                                                        
EPF_IO_15 SI_ALL_01 SI_ALL_02 SI_ALL_03 SI_ALL_04 SI_ALL_05 SI_DEC_01                                                        
SI_DEC_02 SI_DEC_03 SI_PS_01 SI_PS_02 SI_PS_03 SI_DA_01 SI_DA_02                                                             
SI_DA_03 SI_GA_01 SI_GA_02 SI_GA_03 SI_REC_01 SI_REC_02 SI_REC_03                                                            
SI_VT_01 SI_VT_02 SI_VT_03 SI_ARR_01 SI_ARR_02 SI_ARR_03 SI_DM_01                                                            
SI_DM_02 SI_DM_03 SI_CIC_01 SI_CIC_02 SI_CIC_03 SI_QRY_01 SI_QRY_02                                                          
SI_QRY_03 SI_DS_01 SI_DS_02 SI_DS_03 $1. @@;                                                                                 
cards4;                                                                                                                      
                                                                                                                             
;;;;                                                                                                                         
run;quit;                                                                                                                    
                                                                                                                             
* create macro arrays;                                                                                                       
                                                                                                                             
%utlnopts;  * this just turns off the log *;                                                                                 
                                                                                                                             
%array(SHK,values=%utl_varlist(have,prx=/^SHK/));                                                                            
%array(CTI,values=%utl_varlist(have,prx=/^CTI/));                                                                            
%array(CTD,values=%utl_varlist(have,prx=/^CTD/));                                                                            
%array(EPF,values=%utl_varlist(have,prx=/^EPF/));                                                                            
%array(SI ,values=%utl_varlist(have,prx=/^SI/));                                                                             
                                                                                                                             
/* sample                                                                                                                    
                                                                                                                             
%put _user_;                                                                                                                 
                                                                                                                             
GLOBAL SHK1 SHK_1M_SPS                                                                                                       
GLOBAL SHK10 SHK_1M_ALL                                                                                                      
GLOBAL SHK11 SHK_2M_ALL                                                                                                      
GLOBAL SHK12 SHK_3M_ALL                                                                                                      
GLOBAL SHK2 SHK_2M_SPS                                                                                                       
GLOBAL SHK3 SHK_3M_SPS                                                                                                       
GLOBAL SHK4 SHK_1M_SP                                                                                                        
GLOBAL SHK5 SHK_2M_SP                                                                                                        
GLOBAL SHK6 SHK_3M_SP                                                                                                        
GLOBAL SHK7 SHK_1M_SPA                                                                                                       
GLOBAL SHK8 SHK_2M_SPA                                                                                                       
GLOBAL SHK9 SHK_3M_SPA                                                                                                       
                                                                                                                             
GLOBAL SHKN 12          *dimension of array;                                                                                 
*/                                                                                                                           
                                                                                                                             
proc datasets lib=work;                                                                                                      
  modify have ;                                                                                                              
  /* macro array values are substituted for ? */                                                                             
  label                                                                                                                      
     %do_over(SHK , phrase=%str( ? = "BASEBALL SUNDAY ?"    ))                                                               
     %do_over(CTI , phrase=%str( ? = "BASKETBALL MONDAY ?"    ))                                                             
     %do_over(CTD , phrase=%str( ? = "TEMMIS TUESDAY ?"   ))                                                                 
     %do_over(EPF , phrase=%str( ? = "GOLF WEDNESDAY ?" ))                                                                   
     %do_over(SI  , phrase=%str( ? = "TRACK THURSDAY?"  ))                                                                   
  ;                                                                                                                          
  rename                                                                                                                     
     %do_over(SHK , phrase=%str( ? = SUNDAY_?    ))                                                                          
     %do_over(CTI , phrase=%str( ? = MONDAY_?    ))                                                                          
     %do_over(CTD , phrase=%str( ? = TUESDAY_?   ))                                                                          
     %do_over(EPF , phrase=%str( ? = WEDNESDAY_? ))                                                                          
     %do_over(SI  , phrase=%str( ? = THURSDAY_?  ))                                                                          
  ;                                                                                                                          
run;quit;                                                                                                                    
                                                                                                                             
%utlopts; * turn options back on;                                                                                            
                                                                                                                             
/*                                                                                                                           
                                OUTPUT                                                                                       
                                                                                                                             
                            The CONTENTS Procedure                                                                           
                                                                                                                             
                           Variables in Creation Order                                                                       
                                                                                                                             
                                                                                                                             
                     |  RULES RENAME AND ADD A LABEL                                                                         
                                                                                                                             
      OLD COLUMN     |   NEW COLUMN            NEW                                                                           
  #   NAME           |   NAME                  LABEL                                                                         
                     |                                                                                                       
  1   SOURCECODE     |   SOURCECODE                                                                                          
  2   ACCOUNT_NUMBER |   ACCOUNT_NUMBER                                                                                      
  3   SHK_1M_SPS     |   SUNDAY_SHK_1M_SPS     BASKETBALL MONDAY CTI_1M_ALL                                                  
  4   SHK_2M_SPS     |   SUNDAY_SHK_2M_SPS     BASKETBALL MONDAY CTI_1M_SP                                                   
  5   SHK_3M_SPS     |   SUNDAY_SHK_3M_SPS     BASKETBALL MONDAY CTI_1M_SPA                                                  
  6   SHK_1M_SP      |   SUNDAY_SHK_1M_SP      BASKETBALL MONDAY CTI_1M_SPS                                                  
  7   SHK_2M_SP      |   SUNDAY_SHK_2M_SP      BASKETBALL MONDAY CTI_3M_ALL                                                  
  8   SHK_3M_SP      |   SUNDAY_SHK_3M_SP      BASKETBALL MONDAY CTI_3M_SP                                                   
  9   SHK_1M_SPA     |   SUNDAY_SHK_1M_SPA     BASKETBALL MONDAY CTI_3M_SPA                                                  
 10   SHK_2M_SPA     |   SUNDAY_SHK_2M_SPA     BASKETBALL MONDAY CTI_3M_SPS                                                  
 11   SHK_3M_SPA     |   SUNDAY_SHK_3M_SPA     BASKETBALL MONDAY CTI_6M_ALL                                                  
 12   SHK_1M_ALL     |   SUNDAY_SHK_1M_ALL     BASKETBALL MONDAY CTI_6M_SP                                                   
 13   SHK_2M_ALL     |   SUNDAY_SHK_2M_ALL     BASKETBALL MONDAY CTI_6M_SPA                                                  
 14   SHK_3M_ALL     |   SUNDAY_SHK_3M_ALL     BASKETBALL MONDAY CTI_6M_SPS                                                  
...                  |                                                                                                       
...                  |                                                                                                       
115   SI_CIC_03      |   THURSDAY_SI_CIC_03    TRACK THURSDAYSI_CIC_03                                                       
116   SI_QRY_01      |   THURSDAY_SI_QRY_01    TRACK THURSDAYSI_QRY_01                                                       
117   SI_QRY_02      |   THURSDAY_SI_QRY_02    TRACK THURSDAYSI_QRY_02                                                       
118   SI_QRY_03      |   THURSDAY_SI_QRY_03    TRACK THURSDAYSI_QRY_03                                                       
119   SI_DS_01       |   THURSDAY_SI_DS_01     TRACK THURSDAYSI_DS_01                                                        
120   SI_DS_02       |   THURSDAY_SI_DS_02     TRACK THURSDAYSI_DS_02                                                        
                     |                         TRACK THURSDAYSI_DS_03                                                        
                     |                                                                                                       
                     |                                                                                                       
                     |                                                                                                       
*/                                                                                                                           
                                                                                                                             
* remover the macro arrays;;                                                                                                 
                                                                                                                             
%arraydelete(SHK);                                                                                                           
%arraydelete(CTI);                                                                                                           
%arraydelete(CTD);                                                                                                           
%arraydelete(EPF);                                                                                                           
%arraydelete(SI );                                                                                                           
                                                                                                                             
                                                                                                                             
                                                                                                                             
