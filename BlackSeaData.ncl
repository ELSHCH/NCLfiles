load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
dir = "C:/cygwin/home/eshchekinova/BlackSea"

begin
;-------- winter  -----------------------------------------------------------------------------------
 
month_abbr = (/"","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep", \
                    "Oct","Nov","Dec"/);

;---------- INPUT DATA FILES--------------------------------------------------------

uf1 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554708737254.nc","r");  ; Jan 2016-Jan 2017
;uf2 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554709159757.nc","r");  ; Jan 2017-Jan 2018
;uf3 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554709422311.nc","r"); ; Jan 2018 - Apr 2019

;---------- INPUT ZONAL AND MERIDIONAL VELOCITY ---------------------------------

SIZE_LATITUDE =215;
SIZE_LONGITUDE =395;
SIZE_TIME = 1;
SIZE_DEPTH = 1;
;DAY = 1;

;---------------------------------------------------------------------------------

u1  = uf1->vozocrtx(0:SIZE_TIME-1,0:SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)   ; Get u, v, latitude, and longitude data.
v1 = uf1->vomecrty(0:SIZE_TIME-1,0:SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1);
 
   zo_mean_wint=dim_avg_n(u1,1);
   print(dimsizes(zo_mean_wint))
   me_mean_wint=dim_avg_n(v1,1);

   zo_std_wint=dim_stddev_n(u1, 1); 
   me_std_wint=dim_stddev_n(v1, 1); 
   
   lat = u1&lat;
   lon = u1&lon;


  ; time = u&time;
  
  ;utc_date = ut_calendar(time, 0);
  ;year   = tointeger(utc_date(:,0))    ; Convert to integer for
  ;month  = tointeger(utc_date(:,1))    ; use sprinti 
  ;day    = tointeger(utc_date(:,2));
  ;hour   = tointeger(utc_date(:,3));
  ;minute = tointeger(utc_date(:,4));
  ;second = utc_date(:,5);
 ;
 ; Write out strings in the format "dd mmm yyyy".
 ;

  ; date_str = sprinti("%0.2iZ ", hour) + sprinti("%0.2i ", day) + \
            ;  month_abbr(month) + " "  + sprinti("%0.4i", year);
  


    dimlon=dimsizes(lon);
    dimlat=dimsizes(lat);
   
    dimtime=SIZE_TIME;
    npts=dimlon*dimlat;
    data =  new((/2,dimtime,dimlat,dimlon/),"float");
    print(dimsizes(zo_mean_wint))
    npt= -1
     do nt=1,dimtime-1
     print(nt)
    do i=0,dimlat-1
    do j=0,dimlon-1
          data(0,nt,i,j) =  zo_mean_wint(nt,i,j);
          data(1,nt,i,j) =  me_mean_wint(nt,i,j);
       end do
       end do
     end do
  ;  asciiwrite("BlackSeaData.txt",data);   
  ;  asciiwrite("BlackSeatimeData.txt",date_str);  
  ;  asciiwrite("BlackSealon2016.txt",u&lon); 
  ;  asciiwrite("BlackSealat2016.txt",u&lat);    
;-----create seeding positions of particles -----------------------------------
datamap = "C:/cygwin/home/eshchekinova/BlackSea/mapBlackSearegion.txt";
;datamap = "mapregionNorth.txt";
ncols_m = numAsciiCol(datamap);
;print(ncols_m)
nrows_m=numAsciiRow(datamap);
mapdata=asciiread(datamap,(/nrows_m,ncols_m/),"float");
;print(dimsizes(mapdata))

;--------  DRAW MAP  -----------------------------------------------------------------------------------   
 
  wks = gsn_open_wks("pdf","meancurrentBlackSea_DAY_0") ; Open an pdf workstation.
  gsn_define_colormap(wks,"BlAqGrYeOrReVi200");
  wks1 = gsn_open_wks("x11","meancurrentBlackSea") ; Open an X11 workstation.
  gsn_define_colormap(wks1,"BlAqGrYeOrReVi200");
  wks@wkPaperWidthF=10.5;

  wks@wkPaperHeightF=16.0;
  wks@wkOrientation = "landscape";
  wks@wkPaperSize = "A4";
  wks1@wkPaperWidthF=10.5;

  wks1@wkPaperHeightF=16.0;
  wks1@wkOrientation = "landscape";
  wks1@wkPaperSize = "A4";

;------------------------------------------------------------------------------------
  
  res  = True 
  res@cnFillOn            = True
  res@gsnDraw=False
  res@gsnFrame=False
  res@tiXAxisFont   = "Times-Roman"  ; Change the default font used.
  ;res@tmXBLabelFont = "Times-Roman"
  ;res@tmYLLabelFont = "Times-Roman"
  res@gsnSpreadColors     = True         ; use full colormap

  res@cnLineLabelsOn      = False        ; no contour line labels
 res@cnLinesOn      = False        ; no contour line labels
 
  res@gsnMaximize=True;
  res@tiMainString    = "Jul-Aug 2016"; 
  res@tmXBLabelFontHeightF = 0.021
  res@tmYLLabelFontHeightF= 0.021
  res@mpMaxLatF  = max(lat); select subregion
  res@mpMinLatF  = min(lat);
  res@mpMinLonF  = min(lon);
  res@mpMaxLonF  = max(lon);
  res@gsnAddCyclic=False
   res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
  ;res@cnLevels    = (/0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45/)   ; set levels

  dims1=dimsizes(zo_std_wint(0,:,0));
  dims2=dimsizes(zo_std_wint(0,0,:)) ;
;
  dimtime=dimsizes(zo_std_wint(:,0,0));
  att=getvaratts(zo_std_wint);
  print(att)
  speed_flow=new((/dimtime,dims1,dims2/),"float");
  speed_flow1=new((/dimtime,dims1,dims2/),"float");
 
  do i=0,dims1-1
  do j=0,dims2-1
   speed_flow(:,i,j)=sqrt(zo_mean_wint(:,i,j)^2+me_mean_wint(:,i,j)^2);
    speed_flow1(:,i,j)=sqrt(zo_mean_wint(:,i,j)^2+me_mean_wint(:,i,j)^2);
  
  end do
  end do

  do i=0,dims1-1
        do j=0,dims2-1 
           if (mapdata(j+i*dims2,0).eq.0) then
              speed_flow(:,i,j)=0;
           end if;
   end do;
end do;     
speed_flow1=speed_flow;

  do i=1,dims1-2 
         do j=1,dims2-2
         if (mapdata(j+i*dims1,0).eq.0) then
             speed_flow1(:,i,j)=(speed_flow(:,i,j-1)+speed_flow(:,i-1,j-1)+\
                speed_flow(:,i+1,j-1)+\
                speed_flow(:,i+1,j)+speed_flow(:,i-1,j)+\
                speed_flow(:,i,j+1)+speed_flow(:,i-1,j+1)+speed_flow(:,i+1,j+1))/8;
         end if
 end do
end do  



  res@mpDataBaseVersion    = "HighRes"   

;-----------------Draw vector field and streamline
  vcres                         = True
 
  vcres@tmXBLabelFontHeightF = 0.021
  vcres@tmYLLabelFontHeightF= 0.021
  vcres@vcMonoFillArrowEdgeColor = False
  vcres@tiMainString    = "   "; 
 
  vcres@gsnAddCyclic=False
  vcres@mpCenterLonF     = -100.0
  vcres@mpCenterLatF     =   50.0

  vcres@gsnAddCyclic      = False    ; Don't add cyclic longitude point

  vcres@tiMainString      = "  "

  vcres@vcFillArrowsOn          = True
  vcres@gsnRightString          = ""
  vcres@gsnLeftString           = ""
  vcres@vcRefMagnitudeF         = 10.0             ; define vector ref mag
  vcres@vcRefLengthF            = 1.0             ; define length of vec ref
  vcres@vcMinFracLengthF        = 0.5
  vcres@vcMinDistanceF          = 0.01
    vcres@tmYRlabelsOn          = False
  vcres@vcRefAnnoOrthogonalPosF = -0.45
  vcres@vcRefAnnoFontHeightF    = 0.007  

  vcres@vcRefLengthF         = 0.06313608
  vcres@vcMinFracLengthF     = 0.3

  u_mean=dim_avg_n_Wrap(zo_mean_wint,0);
  v_mean=dim_avg_n_Wrap(me_mean_wint,0);
 
  u_mean!0="g0_lat_1"
  u_mean!1="g0_lon_2"
  ;u_mean&forecast_time0=u1&time
  u_mean&g0_lat_1=u1&lat
  u_mean&g0_lon_2=u1&lon
  v_mean!0="g0_lat_1"
  v_mean!1="g0_lon_2"
  v_mean&g0_lat_1=u1&lat
  v_mean&g0_lon_2=u1&lon
  speed_mean=dim_avg_n_Wrap(speed_flow1,0);
  
  speed_flow1!1="g0_lat_1"
  speed_flow1!2="g0_lon_2"
  speed_flow1&g0_lat_1=u1&lat
  ;speed_flow1&forecast_time0=u&time;
  speed_flow1&g0_lon_2=u1&lon
  speed_mean=dim_avg_n_Wrap(speed_flow1,0);
  print(max(speed_mean))
  
  res@gsnAddCyclic=False

  res@cnFillDrawOrder ="Predraw"  ; 
  map1=gsn_csm_contour_map(wks1,speed_mean(::2,::2),res);
  map2=gsn_csm_contour_map(wks,speed_mean(::2,::2),res);

  ;plot1 =gsn_csm_streamline(wks1,u_mean(::10,::10),v_mean(::10,::10),res);
  ;plot2 =gsn_csm_streamline(wks,u_mean(::10,::10),v_mean(::,::10),res);


  ;maximize_output(wks,True);
  ;maximize_output(wks1,True);
  ;overlay(map1,plot1)
  ;overlay(map2,plot2)
  draw(map1)
  draw(map2)
  frame(wks1) 
  frame(wks) 
  delete(res)
  end;



