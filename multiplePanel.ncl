;**********************************************************************
; This script creates a panel of 8 plots (4 rows and 4 columns):
;
;   - the 1st column of plots uses one color map and is represented by a single labelbar
;   - the 2nd and 3rd column of plots uses one color map and is represented by a single labelbar
;   - the 4th column of plots uses one color map and is represented by a single labelbar
;
; This script was written by Appolinaire Derbetini of the Laboratory 
; for Environmental Modelling and Atmospheric Physics, University of 
; Yaounde 1, Yaounde, Cameroon.
; 
; The idea was inspired by the paper of Pokam et al., 2018, Consequences
; of 1.5 C and 2 C global warming levels for temperature and
; precipitation changes over Central Africa, Environ. Res. Lett. 13
; (2018) 055011, https://doi.org/10.1088/1748-9326/aab048
;**********************************************************************

;**********************************************************************
; Simple function that takes the difference of two variables and
; copies the coordinate arrays from one of the variables to the
; difference variable for plotting later.
;**********************************************************************
function diff_vars(x1,x2)
local xdiff
begin
  xdiff = x1-x2
  copy_VarCoords(x1,xdiff)
  return(xdiff)
end

;**********************************************************************
; Function to retrieve the location of a plot so we can calculate
; a location for a title on the left side of the plot.
;**********************************************************************
function get_title_position(plot)
local vpy, vpx, vph
begin
  getvalues plot
      "vpYF"       : vpy
      "vpXF"       : vpx
      "vpHeightF"  : vph
  end getvalues
  pos = (/vpx*0.3,vpy-(vph/2.)/)
  return(pos)
end

;**********************************************************************
; Main code
;**********************************************************************
begin 
   ;Reading Historical data

   fh1     = addfile("CERSAT-GLO-REP_WIND_L4-OBS_FULL_TIME_SERIE_1557993848938.nc", "r")
   
   SIZE_LATITUDE =29;
   SIZE_LONGITUDE =61;
   SIZE_DEPTH = 1;
   SIZE_TIME1 = 23;


    uv     = fh1->eastward_wind(0:SIZE_TIME1-1,0:SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
  vv     = fh1->northward_wind(0:SIZE_TIME1-1,0:SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
  ;wind1     = f1->WIND_P0_L103_GLC0(0:SIZE_TIME1-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
  latitude = fh1->latitude(0:SIZE_LATITUDE-1)
  longitude = fh1->longitude(0:SIZE_LONGITUDE-1)
  ;windSpeed= f1->gridrot_0(0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
  time1 =  fh1->time(0:SIZE_TIME1-1)
  ;time2 =  f2->initial_time0_hours(0:SIZE_TIME2-1)
 
  ;wdir2     = f2->WDIR_P0_L103_GLC0(0:SIZE_TIME2-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
  ;wind2     = f2->WIND_P0_L103_GLC0(0:SIZE_TIME2-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
  
  
  zo_wind=dim_avg_n(uv,1);
  me_wind=dim_avg_n(vv,1);

  ;wdir = array_append_record (wdir1, wdir2, 0)
  ;wind = array_append_record (wind1, wind2, 0)
  ;time = array_append_record (time1, time2, 0)
  


  ;--------------------------------------------------
; get some parameters
;--------------------------------------------------
  dimlat = SIZE_LATITUDE
  dimlon = SIZE_LONGITUDE
  dimtime = SIZE_TIME1

  
  w_speed =  new((/dimtime,dimlat,dimlon/),"float");
 ; copy_VarAtts(wind, w_speed) 

   
   do i=0,dimlon-1
         do j=0,dimlat-1
         do k = 0,dimtime-1
        zo_wind(k,j,i) = zo_wind(k,j,i)*0.01
        me_wind(k,j,i) = me_wind(k,j,i)*0.01
        w_speed(k,j,i) = sqrt(zo_wind(k,j,i)^2 + me_wind(k,j,i)^2)

  end do
  end do
  end do


  zo_wind!1="latitude"
  zo_wind!2="longitude"
  zo_wind!0 = "time"

  zo_wind&time=uv&time
  zo_wind&latitude=uv&latitude
  zo_wind&longitude=uv&longitude

  me_wind!1="latitude"
  me_wind!2="longitude"
  me_wind!0 = "time"

  me_wind&time=uv&time
  me_wind&latitude=uv&latitude
  me_wind&longitude=uv&longitude

  w_speed!1="latitude"
  w_speed!2="longitude"
  w_speed!0 = "time"

  w_speed&time=uv&time
  w_speed&latitude=uv&latitude
  w_speed&longitude=uv&longitude


    
    pltDir = "./"                ; where output will be written
    pltName= "GWL_rain"                                   
    pltType= "png"               ; ps, eps, png, pdf, x11 .....

;****************************************************************************
; Graphic resources
;****************************************************************************
    pltPath = pltDir+pltName
    wks     = gsn_open_wks(pltType, pltPath) 
    cmap = read_colormap_file("gui_default")        ; so we can subset later

    res                            = True     ; plot mods desired
    res@gsnDraw                    = False    ; will panel plots later
    res@gsnFrame                   = False

    res@cnFillOn                   = True     ; turn on color fill
    res@cnLinesOn                  = False    ; turn off contour lines
    res@cnLineLabelsOn             = False    ; turn off contour line labels

;**********************************************************************
; We are turning the labelbar off for all but the bottom row of plots
;**********************************************************************
    res@lbLabelBarOn               = False

    ; Set resources for when we turn on labelbar later
    res@lbTitleFontHeightF         = .03                 ; make title smaller
    res@lbTitleString              = "mm/day"            ; title string
    res@lbTitlePosition            = "Bottom"            ; title position
    res@lbTitleDirection           = "Across"            ; title direction
    res@lbLabelStride              = 2
    res@lbLabelFontHeightF         = 0.025
    res@pmLabelBarHeightF          = 0.1
    res@lbBoxEndCapStyle           = "TriangleBothEnds"
    res@lbOrientation              = "Horizontal"        ; orientation

    ; Set resources for map
    res@mpProjection               = "CylindricalEquidistant"       ; projection
    res@mpLimitMode                = "Corners"                      ; method to zoom
    res@mpLeftCornerLatF           = min(w_speed&latitude)
    res@mpLeftCornerLonF           = min(w_speed&longitude)
    res@mpRightCornerLatF          = max(w_speed&latitude)       
    res@mpRightCornerLonF          = max(w_speed&longitude)
    res@mpFillDrawOrder            = "PostDraw"

    res@mpDataBaseVersion          = "MediumRes"
    res@mpFillOn                   = True    
    res@mpOutlineOn                = True
    res@mpFillOn                   = False                ; turn off gray fill
    res@mpOutlineBoundarySets      = "National"

    res@gsnAddCyclic               = False            ; regional data, don't add cyclic point
 
    ; Set resources for tickmarks
    res@tmYLLabelsOn               = True            ; turn off lat labels
    res@tmXBLabelsOn               = True            ; turn off lon labels
  
    res@tmYROn                     = True
    res@tmYLOn                     = True
    res@tmXTOn                     = True
    res@tmXBOn                     = True

    res@gsnStringFont              = "helvetica-bold"  ; will be used for gsnCenterString later
    res@gsnCenterStringFontHeightF = 0.04              ; ditto
    res@gsnLeftString              = ""                ; remove the left and right substrings
    res@gsnRightString             = ""

   ; Set resources specifically for plots in column 1
    res1                           = res
    ;res1@cnFillPalette             = "MPL_YlGnBu"
    res1@cnFillPalette          = cmap(2:,:)         ; subset the color map
   ; res1@cnLevelSelectionMode      = "ManualLevels"  ; manually specify contour levels
   ; res1@cnMinLevelValF            = 1             ; min level
   ; res1@cnMaxLevelValF            = 12             ; max level
   ; res1@cnLevelSpacingF           =  1.             ; contour interval
   
   ; Set resources specifically for plots in columns 2 & 3
    res2                           = res
    ;res2@cnFillPalette             = "MPL_PuOr"
    res2@cnFillPalette          = cmap(2:,:)         ; subset the color map
   ; res2@cnLevelSelectionMode      = "ManualLevels"  ; manually specify contour levels
   ; res2@cnMinLevelValF            = -1.5             ; min level
   ; res2@cnMaxLevelValF            =  1.5             ; max level
   ; res2@cnLevelSpacingF           =  0.2            ; contour interval
    res2@pmLabelBarWidthF          = 1.05
    res2@pmLabelBarParallelPosF     = -0.02

   ; Set resources specifically for plots in column 4
    ;cmap = read_colormap_file("MPL_bwr") 
    ;cmap = cmap(::-1,:) ; reverse the color map 

    res3                           = res
    ;res3@cnFillPalette             = cmap
    res3@cnFillPalette          = cmap(2:,:)         ; subset the color map
    ;res3@cnLevelSelectionMode      = "ManualLevels"  ; manually specify contour levels
    ;res3@cnMinLevelValF            = -1.             ; min level
    ;res3@cnMaxLevelValF            =  1.             ; max level
    ;res3@cnLevelSpacingF           =  0.2            ; contour interval


    vcres                         = True
    vcres@gsnDraw                 = False
    vcres@gsnFrame                = False

    vcres@vcFillArrowsOn           = True
    vcres@vcLineArrowThicknessF    =  1.0

    vcres@vcMinFracLengthF         = 0.33
    vcres@vcMinMagnitudeF          = 0.001
    vcres@vcMonoFillArrowFillColor = True
    vcres@vcMonoLineArrowColor     = True

    vcres@vcRefLengthF             = 0.045
    vcres@vcRefMagnitudeF          = 5.0
    vcres@vcAnnoFontHeightF = 0.01
    vcres@vcLabelFontHeightF = 0.1
    vcres@vcRefAnnoPerimSpaceF = 0.02
    vcres@vcRefAnnoOrthogonalPosF  = -0.8
    vcres@vcRefAnnoParallelPosF    =  0.997
    vcres@vcRefAnnoFontHeightF     = 0.015


;****************************************************************************
; Create the plots for the panel
;****************************************************************************
    nrow = 4
    ncol = 3                           
    plot = new(nrow*ncol , "graphic")
  
    ; Center strings will be set for top plots only
    res1@gsnCenterString = "CTL:1971-2000"
    plot(0) = gsn_csm_contour_map(wks, w_speed(0,:,:), res1)
    vector = gsn_csm_vector(wks,zo_wind(0,::4,::4),me_wind(0,::4,::4),vcres) 
    overlay(plot(0),vector)

    res2@gsnCenterString = "1.5~S~o~N~ - CTL"
    plot(1) = gsn_csm_contour_map(wks, w_speed(1,:,:), res2)
    vector = gsn_csm_vector(wks,zo_wind(1,::4,::4),me_wind(1,::4,::4),vcres) 
    overlay(plot(1),vector)

    res2@gsnCenterString = "2.0~S~o~N~ - CTL"
    plot(2) = gsn_csm_contour_map(wks, w_speed(2,:,:), res2)
    vector = gsn_csm_vector(wks,zo_wind(2,::4,::4),me_wind(2,::4,::4),vcres) 
    overlay(plot(2),vector)

    res3@gsnCenterString = "2.0~S~o~N~ - 1.5~S~o~N~"
    plot(3) = gsn_csm_contour_map(wks, w_speed(3,:,:), res3)
    vector = gsn_csm_vector(wks,zo_wind(3,::4,::4),me_wind(3,::4,::4),vcres) 
    overlay(plot(3),vector)
   
    ; Turn off center strings for rest of plots
    res1@gsnCenterString = ""
    res2@gsnCenterString = ""
    res3@gsnCenterString = ""
     
    plot(4) = gsn_csm_contour_map(wks, w_speed(4,:,:), res1)
    vector = gsn_csm_vector(wks,zo_wind(4,::4,::4),me_wind(4,::4,::4),vcres) 
    overlay(plot(4),vector)
    plot(5) = gsn_csm_contour_map(wks, w_speed(5,:,:),  res2)
    vector = gsn_csm_vector(wks,zo_wind(5,::4,::4),me_wind(5,::4,::4),vcres) 
    overlay(plot(5),vector)
    plot(6) = gsn_csm_contour_map(wks, w_speed(6,:,:), res2)
    vector = gsn_csm_vector(wks,zo_wind(6,::4,::4),me_wind(6,::4,::4),vcres) 
    overlay(plot(6),vector)
    plot(7) = gsn_csm_contour_map(wks, w_speed(7,:,:),  res3)
    vector = gsn_csm_vector(wks,zo_wind(7,::4,::4),me_wind(7,::4,::4),vcres) 
    overlay(plot(7),vector)
   
    plot(8) = gsn_csm_contour_map(wks, w_speed(8,:,:), res1)
    vector = gsn_csm_vector(wks,zo_wind(8,::4,::4),me_wind(8,::4,::4),vcres) 
    overlay(plot(8),vector)
    plot(9) = gsn_csm_contour_map(wks, w_speed(9,:,:),  res2)
    vector = gsn_csm_vector(wks,zo_wind(9,::4,::4),me_wind(9,::4,::4),vcres) 
    overlay(plot(9),vector)
    plot(10) = gsn_csm_contour_map(wks, w_speed(10,:,:), res2)
    vector = gsn_csm_vector(wks,zo_wind(10,::4,::4),me_wind(10,::4,::4),vcres) 
    overlay(plot(10),vector)
    plot(11) = gsn_csm_contour_map(wks, w_speed(11,:,:),  res3)
    vector = gsn_csm_vector(wks,zo_wind(11,::4,::4),me_wind(11,::4,::4),vcres) 
    overlay(plot(11),vector)
   
    ; Turn on labelbar for bottom four plots
    res1@lbLabelBarOn          = True
   

  
;****************************************************************************
; Draw the panel and label bars
;****************************************************************************
    resP                = True
    resP@gsnMaximize    = True
    resP@gsnFrame       = False
    resP@gsnPanelLeft   = 0.005
    resP@gsnPanelBottom = 0.08 
    resP@gsnPanelSave   = True      ; Save the state of the paneled plots so we can
                                    ; query for text strings locations.
   ;resP@gsnPanelMainString = "Land Only: Tmax: 2 Colorbars"

    gsn_panel(wks, plot, (/nrow,ncol/), resP)  ; plots
  
;**********************************************************************
; Add rotated text strings on left side of paneled plots.
; Use the resized plots to determine the position of the titles
;**********************************************************************
    pos1 = get_title_position(plot(0))         ; 1st row leftmost plot
    pos2 = get_title_position(plot(3))         ; 2nd row leftmost plot
    pos3 = get_title_position(plot(6))         ; 3rd row leftmost plot
    
    txres               = True
    txres@txFontHeightF = 0.012
    txres@txAngleF      = 90.
    gsn_text_ndc(wks, "CCLM (CNRM-CM5)",   pos1(0), pos1(1), txres)
    gsn_text_ndc(wks, "CCLM (EC-EARTH)",   pos2(0), pos2(1), txres)
    gsn_text_ndc(wks, "CCLM (HadGEM2-ES)", pos3(0), pos3(1), txres)
    
     
    frame(wks)
end