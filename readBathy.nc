load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

dir = "C:/cygwin/home/shchekin/Documents/ChapterMed/C4xyz"

begin


  datafile1 = "C:/cygwin/home/eshchekinova/BlackSea/BlackSeaBathy.txt";
  ncols1=numAsciiCol(datafile1);
  nrows1=numAsciiRow(datafile1);
  print(ncols1)
  print(nrows1)
  data=asciiread(datafile1,(/nrows1,ncols1/),"float");
  
 ; print(dimsizes(data))



 ; depth_xy = new((/400,400/),"float");

 ; lat=fspan(41.,48.,400)
 
 ; lon=fspan(27.,42.,400) ; read longitude
  
 
  dimlat = 338;
  dimlon = 711;

  depth_xy = new((/338,711/),"float");
  lon = new((/711/),"float");
  lat = new((/338/),"float");

  do i=0,dimlon-1
  do j=0,dimlat-1
   
  lon(i) = data(j+i*dimlat,0);
  lat(j) = data(j+i*dimlat,1);

   depth_xy(j,i) = data(j+i*dimlat,2);
  end do
  end do

  lat@units="degrees_north";
  lon@units="degrees_east";
  depth_xy!0="lat";
  depth_xy!1="lon";
  depth_xy&lat=lat;
  depth_xy&lon=lon;
  

;************************************************
; create points for selected circle region
;************************************************
xc = 33.2;
yc = 44.5;
 

;--------  draw map  -----------------------------------------------------------------------------------   
  
  wks = gsn_open_wks("png","BathyBlackSea") ; Open an pdf workstation.
  gsn_define_colormap(wks,"GMT_gebco");
  wks1 = gsn_open_wks("x11","BathyBlackSea") ; Open an X11 workstation.
  gsn_define_colormap(wks1,"GMT_gebco");

  wks@wkPaperWidthF=10.5;

  wks@wkPaperHeightF=10.5;
  wks@wkOrientation = "landscape";
  ;wks@wkPaperSize = "A4";

  wks1@wkPaperWidthF=10.5;

  wks1@wkPaperHeightF=10.5;
  wks1@wkOrientation = "landscape";
  ;wks1@wkPaperSize = "A4";

   wks1@wkWidth   =  1024   
   wks1@wkHeight  =  1024   

   res  = True 
  res@cnFillOn            = False;
  res@gsnDraw=False
  res@gsnFrame=False
  

  res@tiXAxisFont   = "Times-Roman"  ; Change the default font used.
  ;res@tmXBLabelFont = "Times-Roman"
  ;res@tmYLLabelFont = "Times-Roman"
  ;res@gsnSpreadColors     = True         ; use full colormap

  res@cnLineLabelsOn      = False        ; no contour line labels
  res@cnLinesOn      = True        ; no contour line labels
  res@cnLineLabelFontHeightF   = 0.026;  
  res@cnInfoLabelFontHeightF   = 0.026;   
 
  res@gsnMaximize=True;
  res@tiMainString    = "Jul-Aug 2016"; 
  res@tmXBLabelFontHeightF = 0.021
  res@tmYLLabelFontHeightF= 0.021
  ;res@lbTitleString        = "bathymetry Black Sea" ; bar title
  res@mpMaxLatF  = max(lat); select subregion
  res@mpMinLatF  = 40.5;
  res@mpMinLonF  = min(lon)-0.2;
  res@mpMaxLonF  = 42.5+0.2;

 
  res@gsnAddCyclic=False
  ;res@mpShapeMode  = "FreeAspect"

  res@vpWidthF              =  0.9           ;-- width of viewport   res@vpHeightF             =  0.68          ;-- height of viewport    ;-- create the first plot   
  res@vpXF                  =  0.12          ;-- start x-position   res@vpYF                  =  1.02          ;-- start y-Position  

   res@lbOrientation         = "vertical"   ;-- vertical label bar   res@lbLabelStride         =  2   
   res@lbLabelPosition       = "Right"       ;-- labelbar labels on left side 
   res@cnExplicitLabelBarLabelsOn = True
   res@pmLabelBarWidthF     = 0.05  

   ;res@pmLabelBarOrthogonalPosF = -1.37     ;-- labelbar on the left side 
  
   res@cnMinLevelValF= -3000. 
   res@cnMaxLevelValF= 0. 
   res@cnLabelBarEndStyle = "ExcludeOuterBoxes" 
   res@lbLabelFontHeightF = 0.015

  ;res  = True ;
  res@cnFillOn            = True;
  ;res@gsnDraw             = False           ;

  ;res@gsnFrame=False;
 
  ;res@tiXAxisFont   = "Times-Roman"  ; Change the default font used.
  ;;res@cnFillMode            = "RasterFill";
  ;;res@tmXBLabelFont = "Times-Roman";
  ;;res@tmYLLabelFont = "Times-Roman";
  res@gsnSpreadColors     = True        ; use full colormap

 

  ;;res@vpXF      = .1                     ; location of where plot starts
  ;;res@vpYF      = .7
 
  ;;res@mpLabelsOn=False
  ;;res@vpWidthF   = 3                          ; make map bigger
  ;res@vpHeightF  =  3         ;
  ;;res@gsnMaximize= False;
  res@tiMainString    = "   "; 

  res@tmXBTickSpacingF = 2.
  res@tmYLTickSpacingF = 2.
  res@pmTickMarkDisplayMode = "Always"   ; Better tickmarks
  res@cnInfoLabelOn = False; 
  ;;res@mpProjection          = "LambertConformal"  
  ;res@mpMaxLatF  = max(lat); select subregion
  ;res@mpMinLatF  = min(lat);
  ;res@mpMinLonF  = min(lon);
  ;res@mpMaxLonF  = max(lon); 
  ;res@gsnSpreadColors     = True         ; use full colormap
  ;res@gsnAddCyclic=False;
  
  res@pmTickMarkDisplayMode = "Always"    ; better map tickmarks

  ; ;cres = 0;
  
  res@cnFillPalette ="GMT_gebco"  ; 

  ;************************************************
 
 ; cres@gsnAddCyclic=False;
 
 res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
 ;res@cnLevelSelectionMode = "Manual"   ; set explicit contour levels
 res@cnLevels    = (/0, -10. -20, -50, -100, -200, -400, -1000, -2000/)   ; set levels
 res@mpLandFillColor   = "bisque"
 res@mpDataBaseVersion    = "HighRes"  
 
 res@cnLineThicknessF = 1.0;

 res@cnLabelMasking        = False              ; do not draw labels over contour 
 
 res@cnLineLabelBackgroundColor = "transparent"
 ;res@cnSpanLinePalette = True;
 ;res@cnLinePalette = "Oceanography";

 res@cnInfoLabelFontHeightF = 0.8;


; cres@cnLineLabelsOn      = True       ; no contour line labels
;  cres@cnLinesOn      = True        ; no contour line labels



  res@gsnAddCyclic=False
 ; res@mpLimitMode = "LatLon";

  res@cnFillDrawOrder ="Predraw"  ;
  

  res@gsnPanelLabelBar = False;
  res@cnFillPatterns = (/1,3,-1/);


 map_data1 =gsn_csm_contour_map(wks1,depth_xy,res);
 map_data =gsn_csm_contour_map(wks,depth_xy,res);


 ;************************************************
; Attach text to plot using plot coordinates.
;************************************************
  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.01;                     ; font smaller. default big
  txres@txFont = 25;

  sres = True;
  sres@gsMarkerIndex = 16;
  sres@gsMarkerColor      = "gray0";
  sres@gsMarkerSizeF      = 6.0;
  sres@gsMarkerOpacityF = 1.0;

  dum11 = gsn_add_text(wks,map_data,"Novorossiysk", 37.790+0.9,44.709+0.1,txres);
  dum12 = gsn_add_text(wks1,map_data1,"Novorossiysk", 37.790+0.9,44.709+0.1,txres);
  pm11=gsn_add_polymarker(wks,map_data,37.790,44.709,sres);
  pm12=gsn_add_polymarker(wks1,map_data1,37.790,44.709,sres);


  dum01 = gsn_add_text(wks,map_data,"Sevastopol",33.5224+0.2, 44.58883 +0.2, txres);
  dum02 = gsn_add_text(wks1,map_data1,"Sevastopol", 33.5224+0.2, 44.58883 +0.2,txres);
  pm01=gsn_add_polymarker(wks,map_data,33.5224,44.58883,sres);
  pm02=gsn_add_polymarker(wks1,map_data1,33.5224,44.58883,sres);

  dum21 = gsn_add_text(wks,map_data,"Odessa", 30.755-0.1,46.48+0.3, txres);
  dum22 = gsn_add_text(wks1,map_data1,"Odessa", 30.755-0.1,46.48+0.3, txres);
  pm21=gsn_add_polymarker(wks,map_data,30.755,46.48,sres);
  pm22=gsn_add_polymarker(wks1,map_data1,30.755,46.48,sres);
   
  dum31 = gsn_add_text(wks,map_data, "Istambul", 29.152, 41.220-0.2, txres);
  dum32 = gsn_add_text(wks1,map_data1, "Istambul", 29.152, 41.220-0.2, txres);
  pm31=gsn_add_polymarker(wks,map_data,29.152, 41.220,sres);
  pm32=gsn_add_polymarker(wks1,map_data1,29.152, 41.220,sres); 

  dum41 = gsn_add_text(wks,map_data, "Gelendzhik", 38.053+0.8,44.536,txres);
  dum42 = gsn_add_text(wks1,map_data1, "Gelendzhik", 38.053+0.8,44.536,txres);
  pm141=gsn_add_polymarker(wks,map_data,38.053+0.1,44.536-0.2,sres);
  pm142=gsn_add_polymarker(wks1,map_data1,38.053+0.1,44.536-0.2,sres);

  dum51 = gsn_add_text(wks,map_data, "Kerch", 36.47, 45.249+0.2, txres);
  dum52 = gsn_add_text(wks1,map_data1, "Kerch", 36.47, 45.249+0.2, txres);
  pm51=gsn_add_polymarker(wks,map_data,36.47, 45.249,sres);
  pm52=gsn_add_polymarker(wks1,map_data1,36.47, 45.249,sres);

  dum61 = gsn_add_text(wks,map_data, "Anapa",37.318+0.5,44.88+0.2,txres);
  dum62 = gsn_add_text(wks1,map_data1, "Anapa",37.318+0.5,44.88+0.2,txres);
  pm61=gsn_add_polymarker(wks,map_data,37.318,44.88,sres);
  pm62=gsn_add_polymarker(wks1,map_data1,37.318,44.88,sres);

  dum71 = gsn_add_text(wks,map_data, "Gagra",40.264+0.6,43.27-0.1, txres);
  dum72 = gsn_add_text(wks1,map_data1, "Gagra",40.264+0.6,43.27-0.1, txres);
  pm71=gsn_add_polymarker(wks,map_data,40.264,43.27,sres);
  pm72=gsn_add_polymarker(wks1,map_data1,40.264,43.27,sres);

  dum81 = gsn_add_text(wks,map_data, "Batumi", 41.634+0.4, 41.6535-0.3,txres);
  dum82 = gsn_add_text(wks1,map_data1, "Batumi", 41.634+0.4, 41.6535-0.3,txres);
  pm81=gsn_add_polymarker(wks,map_data,41.634, 41.6535,sres);
  pm82=gsn_add_polymarker(wks1,map_data1,41.634, 41.6535,sres);

  dum91 = gsn_add_text(wks,map_data, "Suchum",41.127+0.7, 42.816,txres);
  dum92 = gsn_add_text(wks1,map_data1, "Suchum",41.127+0.7, 42.816,txres);
  pm91=gsn_add_polymarker(wks,map_data,41.127, 42.816,sres);
  pm92=gsn_add_polymarker(wks1,map_data1,41.127, 42.816,sres);

  dum101 = gsn_add_text(wks,map_data, "Trabzon", 39.659, 40.993-0.2, txres);
  dum102 = gsn_add_text(wks1,map_data1, "Trabzon", 39.659, 40.993-0.2, txres);
  pm101=gsn_add_polymarker(wks,map_data,39.659, 40.993,sres);
  pm102=gsn_add_polymarker(wks1,map_data1,39.659, 40.993,sres);

  dum111 = gsn_add_text(wks,map_data, "Giresun",38.389+0.2,40.895-0.2, txres);
  dum112 = gsn_add_text(wks1,map_data1, "Giresun",38.389+0.2,40.895-0.2, txres);
  pm111=gsn_add_polymarker(wks,map_data,38.389,40.895,sres);
  pm112=gsn_add_polymarker(wks1,map_data1,38.389,40.895,sres);

  dum121 = gsn_add_text(wks,map_data, "Ordu",37.8736-0.3, 40.999-0.2, txres);
  dum122 = gsn_add_text(wks1,map_data1, "Ordu",37.8736-0.3, 40.999-0.2, txres);
  pm121=gsn_add_polymarker(wks,map_data,37.8736, 40.999,sres);
  pm122=gsn_add_polymarker(wks1,map_data1,37.8736, 40.999,sres);

  dum131 = gsn_add_text(wks,map_data, "Samsun",36.355,41.236-0.3,  txres);
  dum132 = gsn_add_text(wks1,map_data1, "Samsun",36.355,41.236-0.3,  txres);
  pm131=gsn_add_polymarker(wks,map_data,36.355,41.236,sres);
  pm132=gsn_add_polymarker(wks1,map_data1,36.355,41.236,sres);

  dum141 = gsn_add_text(wks,map_data, "Adler", 39.916+0.6,43.4196+0.1,txres);
  dum142 = gsn_add_text(wks1,map_data1, "Adler", 39.916+0.6,43.4196+0.1,txres);
  pm141=gsn_add_polymarker(wks,map_data,39.916,43.4196,sres);
  pm142=gsn_add_polymarker(wks1,map_data1,39.916,43.4196,sres);

  dum151 = gsn_add_text(wks,map_data, "Sochi",39.724+0.4, 43.5656+0.2,txres);
  dum152 = gsn_add_text(wks1,map_data1, "Sochi",39.724+0.4, 43.5656+0.2,txres);
  pm151=gsn_add_polymarker(wks,map_data,39.724, 43.5656,sres);
  pm152=gsn_add_polymarker(wks1,map_data1,39.724, 43.5656,sres);

  dum161 = gsn_add_text(wks,map_data, "Constantza",28.672-0.1,44.045+0.2, txres);
  dum162 = gsn_add_text(wks1,map_data1, "Constantza",28.672-0.1,44.045+0.2, txres);
  pm161=gsn_add_polymarker(wks,map_data,28.672,44.045,sres);
  pm162=gsn_add_polymarker(wks1,map_data1,28.672,44.045,sres);

  dum171 = gsn_add_text(wks,map_data, "Varna",27.965-0.4,43.133+0.2,txres);
  dum172 = gsn_add_text(wks1,map_data1, "Varna",27.965-0.4,43.133+0.2,txres);
  pm171=gsn_add_polymarker(wks,map_data,27.965,43.133,sres);
  pm172=gsn_add_polymarker(wks1,map_data1,27.965,43.133,sres);


  dum181 = gsn_add_text(wks,map_data, "Herson",32.415-0.2,46.506-0.2,txres);
  dum182 = gsn_add_text(wks1,map_data1, "Herson",32.415-0.2,46.506-0.2,txres);
  pm181=gsn_add_polymarker(wks,map_data,32.415,46.506,sres);
  pm182=gsn_add_polymarker(wks1,map_data1,32.415,46.506,sres);


  ;dum191 = gsn_add_text(wks,map_data, "Sozopol",27.679-0.2,42.41088+0.2,txres);
  ;dum192 = gsn_add_text(wks1,map_data1, "Sozopol",27.679-0.2,42.41088+0.2,txres);
  ;pm191=gsn_add_polymarker(wks,map_data,27.679,42.41088,sres);
  ;pm192=gsn_add_polymarker(wks1,map_data1,27.679,42.41088,sres);

  dum201 = gsn_add_text(wks,map_data, "Bourgas",27.517, 42.456+0.2,txres);
  dum202 = gsn_add_text(wks1,map_data1, "Bourgas",27.517, 42.456+0.2,txres);
  pm201=gsn_add_polymarker(wks,map_data,27.517, 42.456,sres);
  pm202=gsn_add_polymarker(wks1,map_data1,27.517, 42.456,sres);

  dum211 = gsn_add_text(wks,map_data, "Balchik",28.167,43.396+0.2, txres);
  dum212 = gsn_add_text(wks1,map_data1, "Balchik",28.167,43.396+0.2, txres);
  pm211=gsn_add_polymarker(wks,map_data,28.167,43.396 ,sres);
  pm212=gsn_add_polymarker(wks1,map_data1,28.167,43.396 ,sres);

  dum221 = gsn_add_text(wks,map_data, "Tsarevo",27.857-0.2,42.167-0.3,txres);
  dum222 = gsn_add_text(wks1,map_data1, "Tsarevo",27.857-0.2,42.167-0.3,txres);
  pm221=gsn_add_polymarker(wks,map_data,27.857,42.167,sres);
  pm222=gsn_add_polymarker(wks1,map_data1,27.857,42.167,sres);

  dum231 = gsn_add_text(wks,map_data, "Mandalia", 28.591-0.7,43.811+0.2,txres);
  dum232 = gsn_add_text(wks1,map_data1, "Mandalia", 28.591-0.7,43.811+0.2,txres);
  pm231=gsn_add_polymarker(wks,map_data,28.591,43.811,sres);
  pm232=gsn_add_polymarker(wks1,map_data1,28.591,43.811,sres);



 ;plot =gsn_csm_contour_map(wks1,depth_xy,res);
 ;plot=gsn_csm_contour(wks,depth_xy,res);
 
 gsres = True;
 gsres@gsMarkerIndex = 16;
 gsres@gsMarkerColor      = "red"; 
 gsres@gsMarkerSizeF      = 20.0;
 gsres@gsMarkerOpacityF = 0.7;
 pm1=gsn_add_polymarker(wks,map_data,xc,yc,gsres);
 pm2=gsn_add_polymarker(wks1,map_data1,xc,yc,gsres);
 
 xc1 = 40.2;
 yc1 = 42.5;
 ;gsres@gsMarkerColor      = "lightblue";  
 pm3=gsn_add_polymarker(wks,map_data,xc1,yc1,gsres);
 pm4=gsn_add_polymarker(wks1,map_data1,xc1,yc1,gsres);
 
  res@mpDataBaseVersion    = "HighRes"   
 ;res@tfDoNDCOverlay = True

 ; cres@gsnMaximize                = True;
  res@gsnMaximize                = True;
 
 ;  overlay(plot,map_data);
 ;  overlay(plot1,map_data1);
 ;  draw(plot);
 ;  draw(plot1);
 ; draw(map_data1)
 ; draw(map_data)

  ;maximize_output(wks,res);
  ;maximize_output(wks1,res);
 
  draw(map_data1)
  draw(map_data)
  frame(wks1) 
  frame(wks) 
  delete(res)
  end;
