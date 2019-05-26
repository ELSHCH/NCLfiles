load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
dir = "C:/cygwin/home/eshchekinova/BlackSea"

begin
;----------------------------------------------------------------------------------------------

;Read mean trajectory data. --------------------------------------------------------------------
  datafile1 = "C:/cygwin/home/eshchekinova/BlackSea/leeway_final_position_0.dat";
  ncols1=numAsciiCol(datafile1);
  nrows1=numAsciiRow(datafile1);
  print(ncols1)
  print(nrows1)
  data1=asciiread(datafile1,(/nrows1,ncols1/),"float");
  traj_x=new((/nrows1/),"float");
  traj_y=new((/nrows1/),"float");
  k=0;
  do i=0,nrows1-1
  if (data1(i,3).eq.11)
     
     traj_x(k)=data1(i,1); ; read longitude
     traj_y(k)=data1(i,2); ; read latitude
     k=k+1;   
  end if
  end do
;
  max_lon=max(data1(:,1));
  max_lat=max(data1(:,2));
  min_lon=min(data1(:,1));
  min_lat=min(data1(:,2));

  ;---read data for plotting search area as a convex polygon -------------------------------------------
;  datafile7 = baseOut+jobid+"/leeway_search_area.dat";
  datafile8 = "C:/cygwin/home/eshchekinova/BlackSea/distr_stranded.dat";
  ncols8=numAsciiCol(datafile8);
  nrows8=numAsciiRow(datafile8);
  data8=asciiread(datafile8,(/nrows8,ncols8/),"float");
  distr=new((/100,100/),"float");
   lon=new((/100/),"float");
   lat=new((/100/),"float");

  do i=0,100-1
  do j=0,100-1
    lon(i)=data8(j+i*100,0);
    lat(j)=data8(j,1);
     distr(j,i)=data8(j+i*100,2);
  end do
  end do
  distr!0="lat"
   distr!1="lon"
   distr&lat=lat
   distr&lon=lon
   distr&lat@units = "degrees_north"
   distr&lon@units = "degrees_east"
   
   if (any(isnan_ieee(distr))) then
    if(.not.isatt(distr,"_FillValue")) then
      distr@_FillValue = default_fillvalue(typeof(distr))
    end if
    replace_ieeenan (distr, distr@_FillValue, 0)
  end if

   print(distr)

  
;--------------open x11 and pdf workstation---------------------------------------------------
  wks = gsn_open_wks("x11","DistrBlackSea") ; Open an X11 workstation.
  wks1 = gsn_open_wks("pdf","DistrBlackSea") ; Open an X11 workstation.

;------------define colormap for both graphical plots------------------------------------------
  gsn_define_colormap(wks,"BlueWhiteOrangeRed");
  gsn_define_colormap(wks1,"BlueWhiteOrangeRed");
  ;gsn_define_colormap(wks1,"BlueWhiteOrangeRed");

  gsn_define_colormap(wks,"WhiteBlueGreenYellowRed");
  gsn_define_colormap(wks1,"WhiteBlueGreenYellowRed");
;-----define resource for sea-land mask ------------------------------
  vcres                         = True
  vcres@gsnDraw                 = False
  vcres@gsnFrame=False
  vcres@gsnMaximize                = True
  vcres@mpGridAndLimbOn=True
  vcres@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  vcres@mpGridLineDashPattern  = 5
  vcres@mpGridLatSpacingF      = 10.0
  vcres@mpGridLonSpacingF      = 10.0

  vcres@tiMainString    = ""; 

;---Graphical window based on the longitudes and latitudes of final positions-------------




  vcres@mpMaxLatF  =max_lat+0.03 ;
  vcres@mpMinLatF  =min_lat-0.03 ;
  vcres@mpMinLonF  = min_lon-0.03;
  vcres@mpMaxLonF  = max_lon+0.03;
 
 vcres@mpDataBaseVersion    = "HighRes" 

  vcres@mpOutlineOn       = True
  vcres@mpLandFillColor   ="moccasin"
  vcres@mpOceanFillColor  = "SteelBlue"
 

 ; plot=gsn_csm_map_ce(wks,vcres);
 ; plot1=gsn_csm_map_ce(wks1,vcres);

 ;draw(plot1)
 ;draw(plot)
;---------------------------------------------------------------------------------------------

  res  = True 
  res@cnFillOn            = True
  res@gsnDraw=False
  res@gsnFrame=False
  res@tiXAxisFont   = "Times-Roman"  ; Change the default font used.
  
  res@gsnSpreadColors     = True         ; use full colormap

 
  res@gsnMaximize=True;
  res@tiMainString    = "  "; 
  res@tmXBLabelFontHeightF = 0.021
  res@tmYLLabelFontHeightF= 0.021
  res@mpMaxLatF  = max_lat-0.08; select subregion
  res@mpMinLatF  = min_lat+0.08;
  res@mpMinLonF  = min_lon;
  res@mpMaxLonF  = max_lon-0.08;
  res@cnLinesOn                 = False        ; Turn off contour lines
  ; res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
 ; res@cnLevels    = (/0.02,0.06,0.1,0.14,0.18,0.22,0.26,0.28/)   ; set levels
  
  res@gsnAddCyclic=False
 ; res@mpLandFillColor   ="SpringGreen"

  
  res@mpDataBaseVersion    = "HighRes"   
  res@cnFillDrawOrder ="Predraw"  ; 

  
   res@gsnMaximize                = True
   plot1=gsn_csm_contour_map(wks1,distr(::1,::1),res);
   plot2=gsn_csm_contour_map(wks,distr(::1,::1),res);


  mpres  = True 
  mpres@gsnDraw=False
  mpres@tiXAxisFont   = "Times-Roman"  ; Change the default font used.
 
  mpres@gsnMaximize=True;
  mpres@tiMainString    = "  "; 
  mpres@tmXBLabelFontHeightF = 0.021
  mpres@tmYLLabelFontHeightF= 0.021
  mpres@mpMaxLatF  = max_lat; select subregion
  mpres@mpMinLatF  = min_lat;
  mpres@mpMinLonF  = min_lon;
  mpres@mpMaxLonF  = max_lon;

  i = NhlNewColor(wks,0.7,0.7,0.7)              ; add gray to colormap
  i = NhlNewColor(wks1,0.7,0.7,0.7)              ; add gray to colormap
  ;mpres@mpLandFillColor       =  "gray"           ; set land to be gray
  ;mpres@tiMainString    = "";
  ; mpres@mpFillOn = True;
   mpres@gsnMaximize=False;


  ;map2=gsn_csm_map(wks,mpres);
  ;map1=gsn_csm_map(wks1,mpres);
 ; overlay(map1,plot1);
 ;  overlay(map2,plot2);
  maximize_output(wks,True);
  maximize_output(wks1,True);


;------------Draw initial markers positions------------------------------------------------
   first    =  True                        ; don't draw
   first@gsMarkerIndex  = 4           ; marker style (circle)
   first@gsMarkerSizeF  = 15.0         ; marker size
   first@gsMarkerColor  = "red"     ; marker color

   ;gsn_polymarker(wks,plot,traj_x,traj_y,first) ; draw start of traj
   ;gsn_polymarker(wks1,plot1,traj_x,traj_y,first) ; draw start of traj
 ;frame(wks1); 
 ;frame(wks); 
  end

