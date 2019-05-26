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

;uf1 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554708737254.nc","r");  ; Jan 2016-Jan 2017
uf2 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554709159757.nc","r");  ; Jan 2017-Dec 2017
uf3 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554709422311.nc","r"); ; Jan 2018 - Apr 2019

;---------- INPUT ZONAL AND MERIDIONAL VELOCITY ---------------------------------

SIZE_LATITUDE =215;
SIZE_LONGITUDE =395;
SIZE_TIME = 365;
SIZE_DEPTH = 1;
;DAY = 1;

;---------------------------------------------------------------------------------

;u1  = uf1->vozocrtx(0:SIZE_TIME-1,SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)   ; Get u, v, latitude, and longitude data.
;v1 = uf1->vomecrty(0:SIZE_TIME-1,SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1);

SIZE_TIME = 365;

u2  = uf2->vozocrtx(0:SIZE_TIME-1,SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)   ; Get u, v, latitude, and longitude data.
v2 = uf2->vomecrty(0:SIZE_TIME-1,SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1);


SIZE_TIME = 471;
 u3  = uf3->vozocrtx(0:SIZE_TIME-1,SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)   ; Get u, v, latitude, and longitude data.
v3 = uf3->vomecrty(0:SIZE_TIME-1,SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1);


uu1 = array_append_record(u2, u3, 0);
vv1 = array_append_record(v2, v3, 0);

SIZE_TIME = 365 + 471;
u = new((/SIZE_TIME,SIZE_DEPTH,SIZE_LATITUDE,SIZE_LONGITUDE/) ,typeof(uu1));
u(:,0,:,:) = uu1;

v = new((/SIZE_TIME,SIZE_DEPTH,SIZE_LATITUDE,SIZE_LONGITUDE/) ,typeof(vv1));
v(:,0,:,:) = vv1;

zo_mean_wint=dim_avg_n(u,1);
me_mean_wint=dim_avg_n(v,1);

   lat = u&lat;
   lon = u&lon;
   time = u&time;
 ;  utc_date = ut_calendar(time, 0);
 ;  year   = tointeger(utc_date(:,0))    ; Convert to integer for
 ;  month  = tointeger(utc_date(:,1))    ; use sprinti 
 ;  day    = tointeger(utc_date(:,2));
 ;  hour   = tointeger(utc_date(:,3));
 ;  minute = tointeger(utc_date(:,4));
 ;  second = utc_date(:,5);
 ;
 ; Write out strings in the format "dd mmm yyyy".
 ;

 ;  date_str = sprinti("%0.2iZ ", hour) + sprinti("%0.2i ", day) + \
 ;             month_abbr(month) + " "  + sprinti("%0.4i", year)
    dimlon=dimsizes(lon);
    dimlat=dimsizes(lat);
    dimtime=dimsizes(time);
    npts=dimlon*dimlat;
    data =  new((/2,dimtime,dimlat,dimlon/),"float");
    print(dimsizes(zo_mean_wint))
    
    

     do nt=0,dimtime-1
    do i=0,dimlat-1
    do j=0,dimlon-1
          data(0,nt,i,j) =  zo_mean_wint(nt,i,j);
          data(1,nt,i,j) =  me_mean_wint(nt,i,j);
        ;  print(i+(dimlon-1)*(j+1+i*dimlat))
         ; print(data(1,nt,i,j))
       ;   data(1,i,j) = me_mean_wint(nt,i,j)
       end do
       end do
     end do
    asciiwrite("meanwinterTotalBlackSea.txt",data);  
   ; asciiwrite("timewinter2013.txt",time);  
   ; asciiwrite("lon2013_2016.txt",u&lon); 
   ; asciiwrite("lat2013_2016.txt",u&lat);   
 ;  print(date_str); 
  ; delete(u1);
  ; delete(v1);     
  ;  delete(u2);
  ; delete(v2);
  ; delete(u3);
  ; delete(v3);     
  ; delete(u4);
  ; delete(v4);
  ; delete(u5);
  ; delete(v5);     
  ;  delete(u6);
  ; delete(v6);
  ; delete(u7);
  ; delete(v7);     
  ; delete(u8);
  ; delete(v8);
  ; delete(uu1);
  ; delete(vv1);     
  ; delete(uu2);
  ; delete(vv2);
  ; delete(uu3);
  ; delete(vv3);     
  ; delete(uu4);
  ; delete(vv4);
  ; delete(u);
  ; delete(v);
   delete(time);
   delete(data);
   end;