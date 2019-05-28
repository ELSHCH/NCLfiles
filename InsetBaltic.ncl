;********************************************************
; annotate_3.ncl
;
; Concepts illustrated:
;   - Adding a map to a contour plot as an annotation
;   - Attaching polylines to a contour plot
;   - Using "getvalues" to retrieve the size of a plot
;   - Adding text to a plot
;   - Generating dummy data using "generate_2d_array"
;   - Drawing a map using the high resolution map outlines
;   - Drawing a map using the medium resolution map outlines
;   - Creating a greyscale color map
;   - Changing the angle of text strings
;
;********************************************************
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   

;
; Add a lat/lon box given a center lat/lon and width of the box in degrees.
;
function add_box(wks,map,center_lat,center_lon,degrees)
begin
  lat_start = center_lat - 0.5/2.
  lon_start = center_lon - degrees/2.
  lat_end   = center_lat + degrees/2.
  lon_end   = center_lon + degrees/2.

  lat_box = (/lat_start,lat_start,lat_end,lat_end,lat_end,lat_start/)
  lon_box = (/lon_start,lon_end,lon_end,lon_start,lon_start,lon_start/)

  lnres                  = True
  lnres@gsLineColor      = "red"
  lnres@gsLineThicknessF = 5.0

; Attach box to map plot.
  ii = gsn_add_polyline(wks,map,lon_box,lat_box,lnres)  

  return(ii)     ; Need to keep this id alive for whole duration of program
end

begin

; read Bathymetry data from .txt file 
  datafile1 = "C:/cygwin/home/eshchekinova/BalticSea/bathyBaltic.txt";
  ncols=numAsciiCol(datafile1);
  nrows=numAsciiRow(datafile1);
  
  data=asciiread(datafile1,(/nrows,ncols/),"float");
  
 
  nlat = 625  ; Number of lat points 
  nlon = 1202 ; Number of lon points


  depth_data = new((/nlat,nlon/),"float");
  lon = new((/nlon/),"float");
  lat = new((/nlat/),"float");

; get longitude, latitude and depth from columns of .text file
  do i=0,nlat-1
  do j=0,nlon-1
   
  lon(j) = data(j+i*nlon,1);
  lat(i) = data(j+i*nlon,0);

   depth_data(i,j) = data(j+i*nlon,2);
  end do
  end do

  min_lat =  min(lat)
  max_lat = max(lat)
  min_lon =  min(lon)
  max_lon = max(lon)

; attach units to longitude and latitude 
  lat@units   = "degrees_north"
  lon@units   = "degrees_east"



; Set up coordinate arrays for 2D data.
  depth_data!0   = "lat"
  depth_data!1   = "lon"
  depth_data&lat = lat
  depth_data&lon = lon

  wks  = gsn_open_wks("pdf","InsetBalticSea")     ; send graphics to pdf file
  wks1  = gsn_open_wks("x11","InsetBalticSea")     ; send graphics to x11 term

;---Set some resources for the base map/contour plot.
  res                       = True

; Generic resources 
  res@gsnMaximize       = True
  res@gsnAddCyclic      = False   ; Don't add cyclic point in longitude.
  res@gsnFrame          = False
  res@gsnDraw           = False

  res@mpDataBaseVersion ="HighRes"
  res@mpOutlineOn       = True

  res@mpMinLatF         = min_lat
  res@mpMaxLatF         = max_lat
  res@mpMinLonF         = min_lon
  res@mpMaxLonF         = max_lon

  res@mpLandFillColor         = "bisque"
 ; res@mpOceanFillColor        = "Gray25"
  res@mpInlandWaterFillColor  = "turquoise"

; Contour stuff
  res@cnFillOn                = True
  res@cnFillPalette           = "cmocean_deep" ; set a color map for bathymetry data
  res@cnLinesOn               = False
  ;res@cnLevelSpacingF         = 250.
 ; res@cnFillMode              = "CellFill"


 res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
 ;res@cnLevelSelectionMode = "Manual"   ; set explicit contour levels
 res@cnLevels    = (/10, 0, -10. -20, -50, -100, -150, -200, -250, -300/)   ; set levels
 res@mpDataBaseVersion    = "MediumRes"  

 res@cnInfoLabelFontHeightF = 0.8;

; Label Bar resources


  res@lbOrientation         = "vertical"   ;-- vertical label bar   res@lbLabelStride         =  2   
  res@lbLabelPosition       = "Right"       ;-- labelbar labels on left side 
  res@cnExplicitLabelBarLabelsOn = True
  res@pmLabelBarWidthF     = 0.05  
  

; Tickmarks
  res@pmTickMarkDisplayMode = "Always"
  res@tmXBLabelFontHeightF = 0.01


  res@cnFillDrawOrder ="Predraw"  ;
  res@gsnPanelLabelBar = False;

  map = gsn_csm_contour_map(wks,depth_data,res)
  map1 = gsn_csm_contour_map(wks1,depth_data,res)


; Add box centered at Boknis Eck station (coordinates 54.08333, 10.000).
  lat_center = 54.08333
  lon_center = 10.0
  nboxes = dimsizes(lat_center)
  boxes = new(nboxes,graphic)
  boxes1 = new(nboxes,graphic)
  do i=0,nboxes-1
    boxes(i) = add_box(wks,map,lat_center(i),lon_center(i),1.5)
    boxes1(i) = add_box(wks1,map1,lat_center(i),lon_center(i),1.5)
  end do

; Set up second, smaller map
  mpres                   = True

  mpres@gsnFrame          = False
  mpres@gsnDraw           = False

; Tickmark stuff
  mpres@pmTickMarkDisplayMode = "Always"
  mpres@tmXBLabelFontHeightF = 0.01

; Map stuff
  mpres@mpDataBaseVersion  ="MediumRes"
  mpres@mpOutlineOn       = True
  mpres@mpMinLatF         = lat_center - 0.5/2
  mpres@mpMaxLatF         = lat_center + 1.5/2
  mpres@mpMinLonF         = lon_center - 1.5/2
  mpres@mpMaxLonF         = lon_center + 1.5/2
 
  mpres@mpLandFillColor         = "bisque"
 ; res@mpOceanFillColor        = "Gray25"
  mpres@mpInlandWaterFillColor  = "turquoise"
  mpres@cnFillPalette           = "cmocean_deep" ; set a color map for bathymetry data
  mpres@cnLinesOn               = False

  mpres@cnFillOn            = True;
  mpres@gsnAddCyclic      = False   ; Don't add cyclic point in longitude.

  mpres@gsnSpreadColors     = True        ; use full colormap
  mpres@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
 ;res@cnLevelSelectionMode = "Manual"   ; set explicit contour levels
 mpres@cnLevels    = (/0, -10, -20, -30, -40, -50, 60/)   ; set levels
 mpres@mpDataBaseVersion    = "HighRes"  


  ; Label Bar resources


  mpres@lbOrientation         = "vertical"   ;-- vertical label bar   
  mpres@lbLabelStride         =  2   
  mpres@lbLabelPosition       = "Right"       ;-- labelbar labels on left side 
  mpres@cnExplicitLabelBarLabelsOn = True
  mpres@pmLabelBarWidthF     = 0.01  

  mpres@cnFillDrawOrder ="Predraw"  ;
  mpres@gsnPanelLabelBar = False;

; Turn off label bar
  mpres@lbLabelBarOn = False 

; Width/height
  mpres@vpHeightF         = 0.25    ; Make this second map smaller.
  mpres@vpWidthF          = 0.25

  map2 = gsn_csm_contour_map(wks,depth_data,mpres)
  map21 = gsn_csm_contour_map(wks1,depth_data,mpres)

  ; Add location of Boknis Eck station and text 
; Add marker resource

  sres = True;
  sres@gsMarkerIndex = 16;
  sres@gsMarkerColor      = "red";
  sres@gsMarkerSizeF      = 7.0;
  sres@gsMarkerOpacityF = 1.0;

; Add text resource  

  txres               = True                     ; text mods desired
  txres@txFontHeightF = 0.015;                     ; font smaller. default big
  txres@txFont = 25;

  dum11 = gsn_add_text(wks,map2,"Boknis Eck",10.0+0.1,54.5-0.2,txres);
  dum12 = gsn_add_text(wks1,map21,"Boknis Eck",10.0+0.1,54.5-0.2,txres);
  pm11=gsn_add_polymarker(wks,map2,10.0,54.5,sres);
  pm12=gsn_add_polymarker(wks1,map21,10.0,54.5,sres);


; Add text string to small map.
  txres               = True
  txres@txFontHeightF = 0.01
  txres@txAngleF      = -45.     ; Rotate text 45 degrees
  text_anno = gsn_add_text(wks,map2,"Boknis Eck",-5,-15,txres)
  text_anno1 = gsn_add_text(wks1,map21,"Boknis Eck",-5,-15,txres)

; Set up some resources to indicate where this text string will be
; attached to small map.
  amres                  = True
  amres@amParallelPosF   = -0.3   ; -0.5 is the left edge of the plot.
  amres@amOrthogonalPosF = -0.45   ; -0.5 is the top edge of the plot.
  amres@amJust           = "TopLeft"

  map_anno = gsn_add_annotation(map, map2, amres)  ; Attach small inset to map.
  map_anno = gsn_add_annotation(map1, map21, amres)  ; Attach small inset to map.

  draw(map)    ; This will draw map1 and map2
  draw(map1)    ; This will draw map1 and map2
  frame(wks);
  frame(wks1);
end