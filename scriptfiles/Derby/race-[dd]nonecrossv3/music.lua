function startMusic()
    setRadioChannel(0)
    song = playSound("song.mp3",true)
outputChatBox ("==========================================")

	outputChatBox("M�zigi Acip Kapatmak �cin M Tusuna Basin")
	outputChatBox ("==========================================")
	outputChatBox ("Script By -RaceR - ism.kundakci@hotmail.com")
	outputChatBox ("==========================================")
end

function makeRadioStayOff()
    setRadioChannel(0)
    cancelEvent()
end

function toggleSong()
    if not songOff then
	    setSoundVolume(song,0)
		songOff = true
		removeEventHandler("onClientPlayerRadioSwitch",getRootElement(),makeRadioStayOff)
	else
	    setSoundVolume(song,1)
		songOff = false
		setRadioChannel(0)
		addEventHandler("onClientPlayerRadioSwitch",getRootElement(),makeRadioStayOff)
	end
end

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),startMusic)
addEventHandler("onClientPlayerRadioSwitch",getRootElement(),makeRadioStayOff)
addEventHandler("onClientPlayerVehicleEnter",getRootElement(),makeRadioStayOff)
addCommandHandler("music",toggleSong)
bindKey("m","down","music")




 


