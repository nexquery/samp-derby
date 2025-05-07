#include <a_samp>
#include <zcmd>
#include <xml>
#include <foreach>
#include <streamer>
#include <sscanf2>
#pragma tabsize 0
#define function%0(%1) 			forward%0(%1); public%0(%1)
#define MAX_mPICKUPS 			700

new Araba[MAX_PLAYERS];
new ivehicle[MAX_PLAYERS]=INVALID_VEHICLE_ID;
new ob[MAX_VEHICLES+1][10];
new objecount[MAX_VEHICLES+1];

new TusAyar[MAX_PLAYERS];
new dpickuptimer;
new ObjAttr[][] =
{
	"model",
	"posX",
	"posY",
	"posZ",
	"rotX",
	"rotY",
	"rotZ",
	"dimension",
	"interior"
};

new spawnpointa[][]=
{
	"posX",
	"posY",
	"posZ",
	"rotZ",
 	"vehicle"
};

new PickAttr[][] =
{
	"posX",
	"posY",
	"posZ",
	"type",
	"vehicle"
};

enum spInfo
{
	sType,
	sCreated,
    Float:sX,
    Float:sY,
    Float:sZz,
    sPickup,
    Text3D:sText
};

new dmPickInfo[MAX_mPICKUPS][spInfo],
	tNitro[MAX_PLAYERS],
	tRepair[MAX_PLAYERS];

new
	nospidd[500],
	Text3D:labeld[500],
	repidd[500],
	dObje[2000],
	Iterator:nospd<500>,
	Iterator:repd<500>;

new bool:yuksektimercalisti;
new derbyslot;
new Iterator:derbyciler<MAX_PLAYERS>;
new derbyno;
new derbynames[4096];
new derbyname[56];
new derbynamess[128][56];
new toplamderby;
new derbysayi;
new derbyde[MAX_PLAYERS char];
new bool:derbystarted;
new Float:derbypos[80][4];
new Float:derbypos1[][4] = {
{-1339.9827,936.1379,1036.0865,19.5010},
{-1328.9376,939.4181,1036.1267,16.9957},
{-1315.2103,945.7599,1036.2079,29.1601},
{-1305.2212,954.6921,1036.3363,39.1634},
{-1293.1498,965.8589,1036.4969,52.7385},
{-1283.2452,980.6981,1036.7284,66.5829},
{-1279.3220,999.2728,1037.0363,92.1110},
{-1285.7322,1017.1756,1037.3488,112.5872},
{-1300.9905,1035.8424,1037.6853,134.1106},
{-1315.2928,1044.4940,1037.8508,147.0050},
{-1326.5814,1050.5635,1037.9728,152.7090},
{-1345.8544,1055.2546,1038.0847,156.9773},
{-1367.8107,1056.8634,1038.1499,154.0884},
{-1390.0088,1059.1499,1038.2267,174.0508},
{-1414.4785,1060.0795,1038.2778,172.8106},
{-1434.5736,1060.1680,1038.3176,182.6507},
{-1460.5209,1054.5433,1038.2697,192.8142},
{-1474.2213,1048.0719,1038.1882,201.3842},
{-1488.7150,1039.7555,1038.0751,203.6821},
{-1508.0194,1023.7763,1037.8416,234.3026},
{-1516.5946,1002.3049,1037.4951,256.7592},
{-1516.6818,984.4377,1037.2042,279.9280},
{-1507.3027,967.3377,1036.9037,299.8385},
{-1493.2797,952.6718,1036.6316,306.6411}
};
new bool:derbybasladi;
new derbyVehicle;
new derbycount;

public OnGameModeInit()
{
    LoadDerbyNames();
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(derbyde{playerid} == 1)
	{
	TusAyar[playerid] = 0;
	derbycount--;
	Iter_Remove(derbyciler,playerid);
	derbyde{playerid} = 0;
	}
	derbyde{playerid} = 0;
	derbycontrol();
	if(derbycount<0)derbycount=0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
if(derbyde{playerid} == 1 && GetPVarInt(playerid,"derbydenciktim") != 1)
{
derbyde{playerid} = 0;
derbycount--;
SetPVarInt(playerid,"derbydenciktim",1);
Iter_Remove(derbyciler,playerid);
}
if(GetPVarInt(playerid,"derbydenciktim") == 1)
{
SetPVarInt(playerid,"derbydenciktim",0);
derbycount--;
}
if(derbycount<0)derbycount=0;
derbyde{playerid} = 0;
derbycontrol();
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
if(derbyde{playerid} == 1)
{
derbyde{playerid} = 0;
TusAyar[playerid] = 0;
derbycount--;
Iter_Remove(derbyciler,playerid);
}
if(derbycount<0)derbycount=0;
derbyde{playerid} = 0;
derbycontrol();
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

CMD:derby(playerid,params[])
{
if(derbystarted != true)
{
ShowPlayerDialog(playerid, 4782, DIALOG_STYLE_LIST,"{47C9F5}« xPro Gaming » {ffffff}Derby",derbynames,"Baþlat","Ýptal");
return 1;
}else if(derbybasladi != true)
{
if(derbycount>=derbyslot-1)return SendClientMessage(playerid,-1,"{F51D89}<!> {FFFFFF}Derby maximum oyuncu sayýsýna ulaþtý. Giremezsiniz !");
SetPlayerVirtualWorld(playerid,30);
TogglePlayerControllable(playerid,false);
derbyde{playerid} = 1;
SetPVarInt(playerid,"derbyKomutEngel",1);
SetPVarInt(playerid,"derbyTamirEngel",1);
TusAyar[playerid] = 0;
if(derbyno == 1)
{
SetPVarInt(playerid,"derbyKomutEngel",1);
SetPVarInt(playerid,"derbyTamirEngel",1);
TusAyar[playerid] = 0;
CreatePlayerVehicle(playerid,503);
SetPlayerInterior(playerid, 15);
LinkVehicleToInterior(ivehicle[playerid], 15);
SetVehiclePos(ivehicle[playerid],derbypos1[derbycount][0],derbypos1[derbycount][1],derbypos1[derbycount][2]+1.5);
SetVehicleZAngle(ivehicle[playerid],derbypos1[derbycount][3]);
}
else
{
SetPVarInt(playerid,"derbyKomutEngel",1);
SetPVarInt(playerid,"derbyTamirEngel",1);
TusAyar[playerid] = 0;
SetPlayerPos(playerid,derbypos[derbycount][0],derbypos[derbycount][1],derbypos[derbycount][2]+3);
SetPlayerFacingAngle(playerid,derbypos[derbycount][3]);
SetTimerEx("aracver",2000,false,"d",playerid);
SendClientMessage(playerid,-1,"{F51D89}<!> {FFFFFF}Birazdan araçlarýnýz otomatik olarak verilecek.");
}
if(derbycount<0)derbycount=0;
derbycount++;
ResetPlayerWeapons(playerid);
Iter_Add(derbyciler,playerid);
}else return SendClientMessage(playerid,-1,"{F51D89}<!> {FFFFFF}Derby þuanda aktif, lütfen bitmesini bekleyin.");
return 1;
}

CMD:ayril(playerid,params[])
{
if(derbyde{playerid} == 1)
{
DestroyVehicleEx(ivehicle[playerid]);
derbyde{playerid} = 0;
Araba[playerid] = 0;
SetPlayerVirtualWorld(playerid,0);
SetPlayerInterior(playerid, 0);
TusAyar[playerid] = 0;
derbycount--;
Iter_Remove(derbyciler,playerid);
SpawnPlayer(playerid);
}
if(derbycount<0)derbycount=0;
derbyde{playerid} = 0;
derbycontrol();
if(derbyde{playerid} == 1)
{
GameTextForPlayer(playerid,"~p~~h~/ayril",2500,5);
}
return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
if(newstate == PLAYER_STATE_DRIVER)
{
if(derbyde{playerid} == 0)SetPlayerArmedWeapon(playerid,0);
}
if(derbyde{playerid} == 1)
{
PutPlayerInVehicle(playerid, ivehicle[playerid], 0);
}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
if(newkeys & KEY_LOOK_BEHIND && IsPlayerInAnyVehicle(playerid))
{
if(!IsNosVehicle(GetPlayerVehicleID(playerid))){
RepairVehicle(GetPlayerVehicleID(playerid));
PlayerPlaySound(playerid, 1133 ,0, 0, 0);
GameTextForPlayer(playerid,"~b~~h~~h~Tamir Edildi",1000,4);
return 1;
}
AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
RepairVehicle(GetPlayerVehicleID(playerid));
PlayerPlaySound(playerid, 1133 ,0, 0, 0);
GameTextForPlayer(playerid,"~g~~h~~h~Tamir ~w~~h~+ ~r~~h~~h~~h~Nitro",1000,4);
}
	return 1;
}

IsNosVehicle(vehicleid)
{
    #define NO_NOS_VEHICLES 29

    new InvalidNosVehicles[NO_NOS_VEHICLES] =
    {
   		581,523,462,521,463,522,461,448,468,586,
   		509,481,510,472,473,493,595,484,430,453,
   		452,446,454,590,569,537,538,570,449
    };

	for(new i = 0; i < NO_NOS_VEHICLES; i++)
	{
	    if(GetVehicleModel(vehicleid) == InvalidNosVehicles[i])
	    {
	        return false;
	    }
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == 4782)
{
if(!response)return 1;
if(derbystarted == true)return 1;
if(listitem == 0)
{
TusAyar[playerid] = 0;
derbycount=0;
derbyno=1;
derbybasladi = false;
derbystarted = true;
derbysayi = 25;
TogglePlayerControllable(playerid,false);
derbyslot = sizeof(derbypos1);
derbyde{playerid} = 1;
Iter_Add(derbyciler,playerid);
SetTimer("DerbySay",999,false);
SetPlayerVirtualWorld(playerid,30);
CreatePlayerVehicle(playerid,503);
SetPlayerInterior(playerid, 15);
LinkVehicleToInterior(ivehicle[playerid], 15);
SetVehiclePos(ivehicle[playerid],derbypos1[derbycount][0],derbypos1[derbycount][1],derbypos1[derbycount][2]+3);
SetVehicleZAngle(ivehicle[playerid],derbypos1[derbycount][3]);
derbycount++;
//format(textmesaj,250,"~g~~h~~h~[Derby] ~r~~h~~h~%s~w~~h~ adli oyuncu Derby' i baslatti. Katilmak icin ~y~~h~/derby ~w~~h~kullanin.",getName(playerid));
//Textdrawyazi(-1, textmesaj);
for(new i = 0; i <= MAX_PLAYERS; i++) if(IsPlayerConnected(i)) PlayerPlaySound(i,1057,0.0,0.0,0.0);
return 1;
}
derbyno=0;
if((listitem-1)>toplamderby)return SendClientMessage(playerid,-1,"{F51D89}<!> {FFFFFF}Map hatalý, baþka map seçin.");
derbybasladi = false;
derbystarted = true;
derbysayi = 20;
SendClientMessage(playerid,-1,"{F51D89}<!> {FFFFFF}Harita yükleniyor, lütfen bekleyin !");
if(IsPlayerInAnyVehicle(playerid))RemovePlayerFromVehicle(playerid);
DerbyYukle(derbynamess[listitem-1]);
SetTimer("DerbySay",999,false);
derbycount = 0;
SetTimerEx("Derbygir",100,false,"d",playerid);
}
	return 1;
}

forward derbycontrol();
public derbycontrol()
{
if(derbybasladi !=true)return 1;
if(derbystarted != true)return 1;
if(Iter_Count(derbyciler) <= 1)
{
derbycount = 0;
if(derbyno != 1)
{
KillTimer(dpickuptimer);
for(new z;z<2000;z++)DestroyDynamicObject(dObje[z]),dObje[z]=0;
for(new z;z<500;z++)DestroyDynamic3DTextLabel(labeld[z]),labeld[z]=Text3D:0;
for(new z;z<500;z++)DestroyDynamicPickup(repidd[z]),repidd[z]=0;
Iter_Clear(nospd);
Iter_Clear(repd);
}
derbystarted = false;
derbybasladi = false;
foreach(new i:derbyciler)
{
if(derbyde{i} == 1)
{
GivePlayerMoney(i,5000);
SetPVarInt(i,"derbyKomutEngel",0);
SetPVarInt(i,"derbyTamirEngel",0);
TusAyar[i] = 0;
//RemovePlayerFromVehicle(i);
DestroyVehicleEx(ivehicle[i]);
Araba[i] = 0;
SetPVarInt(i,"derbydenciktim",0);
SetPlayerVirtualWorld(i, 0);
SetPlayerInterior(i, 0);
SpawnPlayer(i);
SetPlayerScore(i,GetPlayerScore(i)+10);
GameTextForPlayer(i,"~r~~h~Derbyi kazandin ~n~~b~~h~10~w~~h~ skor + ~b~~h~5000$",5000,3);
//format(textmesaj,250,"~g~~h~~h~[Derby] ~w~~h~Oyuncu ~r~~h~~h~%s ~w~~h~derbyi kazandi. Odul: ~y~~h~10 Skor + 5000$",getName(i));
//Textdrawyazi(-1, textmesaj);
if(IsPlayerConnected(i)) PlayerPlaySound(i,1057,0.0,0.0,0.0);
//DerbyPlayer = 0;
break;
}
}
Iter_Clear(derbyciler);
}
return 1;
}

forward CozBeni(playerid);
public CozBeni(playerid)
{
	if(derbyde{playerid} == 1)return 1;
    TogglePlayerControllable(playerid, 1);
    return 1;
}

function LoadDerbyNames()
{
	new
	    rNameFile[64],
	    string[256],
	    count=0,
	    derbynameb[64]
	;
	derbynames[0]=EOS;
	format(derbynames,sizeof(derbynames),"{FFCC00}01. {FFFFFF}Klasik Derby");
	format(rNameFile, sizeof(rNameFile), "/Derby/DerbyNames.txt");
	new File:mag = fopen(rNameFile, io_read);
    while(fread(mag, string)>0){
    sscanf(string,"s[128] ",derbynamess[count]);
    format(derbynameb,64,"%s",derbynamess[count]);
    derbynameb[0] = toupper(derbynameb[0]);
    derbynameb[6] = toupper(derbynameb[6]);
    derbynameb[7] = toupper(derbynameb[7]);
    derbynameb[9] = toupper(derbynameb[9]);
    format(derbynames,sizeof(derbynames),"%s\n{FFCC00}%02d. {FFFFFF}%s",derbynames,count+2,derbynameb);
    count++;
    }
    fclose(mag);
    toplamderby = count;
	return 1;
}

stock CreateDynamicMagObject(modelid,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz)
{
	new obje;
	obje = CreateDynamicObject(modelid,x,y,z,rx,ry,rz,10);
	return obje;
}

stock CreateDerbyPickup(picount,modelid,tip,Float:x,Float:y,Float:z){
//CreateDynamicPickup(modelid, tip, x,y,z,10,-1,-1,300);
    new pickup = CreateDynamicPickup(modelid, tip, x, y, z,-1,-1,-1,300.0);
    dmPickInfo[picount][sX] = x;
    dmPickInfo[picount][sY] = y;
    dmPickInfo[picount][sZz] = z;
    return pickup;
}

function aracver(playerid)
{
    if(Araba[playerid] == 1) DestroyVehicleEx(ivehicle[playerid]);
    new Float:x,Float:y,Float:z,Float:a;
    GetPlayerPos(playerid,x,y,z);
    GetPlayerFacingAngle(playerid,a);
	ivehicle[playerid] = CreateVehicle(derbyVehicle, x, y, z, a, -1, -1, (60 * 60)),Araba[playerid] = 1;
	SetVehicleVirtualWorld(ivehicle[playerid],30);
    SetVehicleNumberPlate(ivehicle[playerid], "{FF0015}xPro !");
    PutPlayerInVehicle(playerid, ivehicle[playerid], 0);
    TogglePlayerControllable(playerid,0);
	return 1;
}

forward GenelTimer2();
public GenelTimer2(){
    if(derbybasladi == true)
	{
	derbycontrol();
	}
    if(derbybasladi == true && yuksektimercalisti == false)
	SetTimer("YukseklikKontrol",999,false),yuksektimercalisti=true;
	return 1;
}

function DerbyYukle(dname[])
{
    #define NAN (Float:0x7FFFFFFF)
	new surecount = GetTickCount();
	new File[128],
	    Str[9][40],
	    buf[50],
	    obcount,
	    picount,
	    spawnco,
	    mapname[64]
		;
	format(File,128,"/Derby/%s/meta.xml",dname);
	if(!fexist(File))return printf("%s eksik!",File);
	new XML:Map = xml_open(File);
	xml_get_string(Map,"meta/info/@name",derbyname);
	xml_get_string(Map,"meta/map/@src",mapname);
	xml_close(Map);
	format(File,128,"/Derby/%s/%s",dname,mapname);
	if(!fexist(File))return printf("%s eksik!",File);
	Map = xml_open(File);
    new spawnp = xml_get_int(Map,"count(map/spawnpoint)");
    new Objectp = xml_get_int(Map,"count(map/object)");
    new Racepick = xml_get_int(Map,"count(map/racepickup)");
    new Max1 = max(spawnp,Objectp);
    new Max = max(Max1,Racepick);
    for(new a=1,b=Max+1; a<b; a++)
	{
		if(Objectp != 0 && Objectp >= a)
 		{
			for(new c=0; c<sizeof(ObjAttr); c++)
			{
            	format(Str[c], sizeof(Str[]), "map/object[%d]/@%s",a,ObjAttr[c]);
            }
            dObje[obcount] = CreateDynamicObject(xml_get_int(Map,Str[0]),xml_get_float(Map,Str[1]),xml_get_float(Map,Str[2]),xml_get_float(Map,Str[3]),xml_get_float(Map,Str[4]),xml_get_float(Map,Str[5]),xml_get_float(Map,Str[6]),30);
            obcount++;
		}
        if(spawnp != 0 && spawnp >=a)
        {
            for(new c=0; c<sizeof(spawnpointa); c++)
            {
                format(Str[c], sizeof(Str[]), "map/spawnpoint[%d]/@%s",a,spawnpointa[c]);
			}
			derbypos[spawnco][0] = xml_get_float(Map,Str[0]);
			derbypos[spawnco][1] = xml_get_float(Map,Str[1]);
			derbypos[spawnco][2] = xml_get_float(Map,Str[2]);
			derbypos[spawnco][3] = xml_get_float(Map,Str[3]);
			if(derbypos[spawnco][3] != derbypos[spawnco][3])
			{
			format(Str[3], sizeof(Str[]), "map/spawnpoint[%d]/@rotation",a);
			derbypos[spawnco][3] = xml_get_float(Map,Str[3]);
			}
			derbyVehicle = xml_get_int(Map,Str[4]);
			spawnco++;
		}
		if(Racepick != 0 && Racepick >=a)
		{
		    for(new c=0; c<sizeof(PickAttr); c++)
            {
                format(Str[c], sizeof(Str[]), "map/racepickup[%d]/@%s",a,PickAttr[c]);
			}
			xml_get_string(Map,Str[3],buf);
            if(!strcmp(buf,"nitro",true))
            {
            nospidd[picount] = CreateDerbyPickup(picount,1010,23,xml_get_float(Map,Str[0]),xml_get_float(Map,Str[1]),xml_get_float(Map,Str[2]));
            labeld[picount] = CreateDynamic3DTextLabel("{FFFFFF}[ {15FF00}Nitro {FFFFFF}]",-1,xml_get_float(Map,Str[0]),xml_get_float(Map,Str[1]),xml_get_float(Map,Str[2])+0.7,100.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
			Iter_Add(nospd,picount);
			}else if(!strcmp(buf,"repair",true)){
            repidd[picount] = CreateDerbyPickup(picount,3096,23,xml_get_float(Map,Str[0]),xml_get_float(Map,Str[1]),xml_get_float(Map,Str[2]));
		    labeld[picount] = CreateDynamic3DTextLabel("{FFFFFF}[ {15FF00}Tamir {FFFFFF}]",-1,xml_get_float(Map,Str[0]),xml_get_float(Map,Str[1]),xml_get_float(Map,Str[2])+0.7,100.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
			Iter_Add(repd,picount);
			}
            picount++;
		}
	}
	xml_close(Map);
	derbyslot = spawnco;
	return printf("[Derby]%s isimli map %d ms de basariyla baslatildi",mapname,GetTickCount()-surecount);
}
forward DerbySay();
public DerbySay()
{
new string[256];
format(string,256,"~r~~h~%d ~w~~h~Saniye ~w~~h~Kaldi",derbysayi);
foreach(new i : derbyciler){
GameTextForPlayer(i,string,5000,3);
}
if(derbysayi <= 0){
foreach(new playerid : derbyciler){
if(!IsPlayerInAnyVehicle(playerid))PutPlayerInVehicle(playerid,ivehicle[playerid],0);
}
DerbyBasla();
return 1;
}else SetTimer("DerbySay",999,false);
return derbysayi--;
}

forward DerbyBasla();
public DerbyBasla()
{
if(Iter_Count(derbyciler) <= 1){
derbystarted=false;
KillTimer(dpickuptimer);
//format(textmesaj,250,"~g~~h~~h~[Derby] ~w~~h~Derby iptal edildi.");
//Textdrawyazi(-1, textmesaj);
foreach(new i:derbyciler){Araba[i] = 0;SetPlayerVirtualWorld(i,0);SetPlayerInterior(i, 0);SetPVarInt(i,"derbyKomutEngel",0);SetPVarInt(i,"derbyTamirEngel",0);TusAyar[i] = 0;SetPVarInt(i,"derbydenciktim",0);DestroyVehicleEx(ivehicle[i]);SpawnPlayer(i);break;} // spawnplayer
derbycount =0;
//DerbyPlayer = 0;
if(derbyno == 0){
for(new z;z<2000;z++)DestroyDynamicObject(dObje[z]),dObje[z]=0;
for(new z;z<500;z++)DestroyDynamic3DTextLabel(labeld[z]),labeld[z]=Text3D:0;
for(new z;z<500;z++)DestroyDynamicPickup(repidd[z]),repidd[z]=0;
Iter_Clear(nospd);
Iter_Clear(repd);
}
Iter_Clear(derbyciler);
return 1;
}
derbybasladi = true;
if(derbyno != 1)SetTimer("YukseklikKontrol",999,false),
dpickuptimer = SetTimer("dPickupCheck",100,true);
foreach(new i:derbyciler){
GameTextForPlayer(i,"~r~~h~Derby Basladi",5000,5);
TogglePlayerControllable(i,true);
if(derbyno == 1)GivePlayerWeapon(i, 29, 50000);
}
return 1;
}

forward YukseklikKontrol();
public YukseklikKontrol()
{
    yuksektimercalisti=false;
	new Float:x,Float:y,Float:z;
	foreach(new i:derbyciler){
	if(i >= MAX_PLAYERS)continue;
	GetVehiclePos(GetPlayerVehicleID(i),x,y,z);
	if(z <= 0){
	derbyde{i} = 0;
	//RemovePlayerFromVehicle(i);
	DestroyVehicleEx(ivehicle[i]);
	Araba[i] = 0;
	//DerbyPlayer--;
	GameTextForPlayer(i,"~r~~h~Dustun",3000,3);
	SetPVarInt(i,"derbydenciktim",1);
	SetPVarInt(i,"derbyKomutEngel",0);
	SetPVarInt(i,"derbyTamirEngel",0);
	TusAyar[i] = 0;
	SetPVarInt(i,"derbydenciktim",0);
	SetPlayerVirtualWorld(i,0);
	SetPlayerInterior(i, 0);
	SpawnPlayer(i);
	new next;
    Iter_SafeRemove(derbyciler, i, next);
    i = next;
	}
	}
	#pragma unused y
	#pragma unused x
	derbycontrol();
	if(derbybasladi == true && yuksektimercalisti != true)SetTimer("YukseklikKontrol",999,false);
	yuksektimercalisti=true;
	return 1;
}
function dPickupCheck()
{

foreach(new i:derbyciler)
{
foreach(new c:nospd)
{
if(IsPlayerInRangeOfPoint(i, 3.5, dmPickInfo[c][sX], dmPickInfo[c][sY], dmPickInfo[c][sZz]))
{
if(IsPlayerInAnyVehicle(i)) {
if(GetTickCount() - tNitro[i] > 3000) {
tNitro[i] = GetTickCount();
AddVehicleComponent(GetPlayerVehicleID(i), 1010);
PlayerPlaySound(i, 1133 ,0, 0, 0);
}
}
}
}
foreach(new c:repd)
{
if(IsPlayerInRangeOfPoint(i, 3.5, dmPickInfo[c][sX], dmPickInfo[c][sY], dmPickInfo[c][sZz]))
{
if(IsPlayerInAnyVehicle(i)) {
if(GetTickCount() - tRepair[i] > 3000) {
tRepair[i] = GetTickCount();
RepairVehicle(GetPlayerVehicleID(i));
PlayerPlaySound(i, 1133 ,0, 0, 0);
}
}
}
}
}
return 1;
}

function Derbygir(playerid)
{
TogglePlayerControllable(playerid,0);
TusAyar[playerid] = 0;
SendClientMessage(playerid,-1,"{F51D89}<!> {FFFFFF}Derby haritasý yüklendi, iyi oyunlar !");
SetPlayerPos(playerid,derbypos[derbycount][0],derbypos[derbycount][1],derbypos[derbycount][2]+1.7);
SetPlayerFacingAngle(playerid,derbypos[derbycount][3]);
derbycount++;
SetPlayerVirtualWorld(playerid,30);
ResetPlayerWeapons(playerid);
TogglePlayerControllable(playerid,false);
SetTimerEx("aracver",1500,false,"d",playerid);
derbyde{playerid} = 1;
Iter_Add(derbyciler,playerid);
//format(textmesaj,250,"~g~~h~~h~[Derby] ~r~~h~%s~w~~h~ adli oyuncu Derby' i baslatti. Katilmak icin ~y~~h~/derby ~w~~h~kullanin.",getName(playerid));
//Textdrawyazi(-1, textmesaj);
for(new i = 0; i <= MAX_PLAYERS; i++) if(IsPlayerConnected(i)) PlayerPlaySound(i,1057,0.0,0.0,0.0);
		return 1;
}

forward DestroyVehicleEx(&vehicleid);
public DestroyVehicleEx(&vehicleid)
{
if(vehicleid != INVALID_VEHICLE_ID && vehicleid > 0 && vehicleid <= 2000)
{
for(new i;i<objecount[vehicleid];i++)
{
DestroyDynamicObject(ob[vehicleid][i]);
}
DestroyVehicle(vehicleid);
objecount[vehicleid]=0;
vehicleid = INVALID_VEHICLE_ID;
}
return 1;
}

function CreatePlayerVehicle( playerid, modelid )
{
//if(GetPVarInt(playerid, "SpawnBolgeYasagi") == 1) return SendClientMessage(playerid,-1,"{F51D89}<!> {FFFFFF}Spawn bölgesinde araç indiremezsiniz.");
new Float:x, Float:y, Float:z, Float:angle;
if(IsPlayerInAnyVehicle(playerid)){
GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
GetVehicleZAngle(GetPlayerVehicleID(playerid),angle);
}else{
GetPlayerPos(playerid, x,y,z);
GetPlayerFacingAngle(playerid, angle);
}
if(IsPlayerInAnyVehicle(playerid))RemovePlayerFromVehicle(playerid);
if(Araba[playerid] == 1) RemovePlayerFromVehicle(playerid), DestroyVehicleEx(ivehicle[playerid]), Araba[playerid] = 0;
ivehicle[playerid] = CreateVehicle( modelid, x, y, ( z + 1 ), angle, -1, -1, -1);Araba[playerid] = 1;
SetVehicleNumberPlate(ivehicle[playerid], "{FF0015}xPro !");
LinkVehicleToInterior( ivehicle[playerid], GetPlayerInterior( playerid ) );
SetVehicleVirtualWorld( ivehicle[playerid], GetPlayerVirtualWorld( playerid ) );
PutPlayerInVehicle( playerid, ivehicle[playerid], 0 );
SetPlayerArmedWeapon(playerid,0);
return 1;
}
