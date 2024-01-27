--[[
	Vozath/Typ here :3, I'm adding this note for information.
	
	
	
	[Stipulations]
		YOU MUST AGREE TO THE FOLLOWING STIPULATIONS TO USE THIS MODULE
	
		You MAY use this in ANY project/game of yours for FREE 
		You ARE NOT ALLOWED TO REMOVE OR EDIT THE CREDITS IN ANY WAY SHAPE OR FORM
		You MAY modify the module/config file to your liking/coding style but you MAY NOT DISTRIBUTE THIS MODULE OR ANY MODIFICATIONS OF THIS MODULE AS YOUR OWN (THE ONLY OFFICAL SOURCES ARE THE ROBLOX TOOLBOX AND MY GITHUB)
		You MAY NOT SELL THIS MODULE OR ANY MODIFICATIONS OF THIS MODULE FOR YOUR OWN PROFIT
		
		If you have any questions or concerns, please contact me on Discord: Vozath(492526161230954497)
		
	[Extra Note]
		I originally created this as a thing for my group's projects to keep my networking events usage down to a single of each type for organization and ease :3, I coded nearly the entire thing but it is published under my Roblox group Geggo Studios as a module	
	
	[Credits]
		Vozath/Typ - Main code and structure :3
		TheDarkHeross/Darkness - Error logging system 
]]--

local RemoteEvent:RemoteEvent, RemoteFunction:RemoteFunction, BindableEvent:BindableEvent, BindableFunction:BindableFunction;

local Config = require(script.Config);
local Networker = {};

Networker.IsClient = game:GetService("RunService"):IsClient();

--[CallbackHolders]--
Networker.RemoteEventCallbacks = {};
Networker.BindableEventsCallbacks = {};

Networker.RemoteFunctionCallbacks = {};
Networker.BindableFunctionCallbacks = {};
--[CallbackHolders]--

local function AddTabs(Num)
	local str = '';
	for i = 1,Num do
		str = str.."		";
	end;
	return str;
end;

local function ErrorInfo(Problem,TraceBack)
	local InfoStr = [[]];
	local DefualtStr = [[

		[Networker]: Error Detected.
		
	- - - - - - - - -
	]]
	if Problem then
		InfoStr = InfoStr.."\n"..AddTabs(1)..Problem;
		InfoStr = InfoStr.."\n"..[[
		TraceBack: 
		]].."\n"..AddTabs(2)..(TraceBack or "Unable to preform TraceBack.");
		return DefualtStr..InfoStr.."\n"..AddTabs(1).."- - - - - - - - -\n [Networker]";
	end;
	return DefualtStr..[[
		Unable to dectect error cause.
		Please check over syntax and verify your use cases.
		- - - - - - - - -
		
		]];
end;

local function RandomString(Length)
	local RandomString = "";
	for i = 1,Length do
		RandomString = RandomString..string.char(math.random(1,255));
	end;
	return RandomString;
end;

if Networker.IsClient then
	RemoteEvent = script:FindFirstChildOfClass("RemoteEvent");
	RemoteFunction = script:FindFirstChildOfClass("RemoteFunction");
	BindableEvent = script:FindFirstChildOfClass("BindableEvent");
	BindableFunction = script:FindFirstChildOfClass("BindableFunction");
	if Config.FakeNetworkObjectsAmount and typeof(Config.FakeNetworkObjectsAmount) == "number" and Config.FakeNetworkObjectsAmount >= 1 then
		for i = 1,Config.FakeNetworkObjectsAmount do
			Instance.new("RemoteEvent",script).Name = RandomString(Config.RandomStringLength);
			Instance.new("RemoteFunction",script).Name = RandomString(Config.RandomStringLength);
			Instance.new("BindableEvent",script).Name = RandomString(Config.RandomStringLength);
			Instance.new("BindableFunction",script).Name = RandomString(Config.RandomStringLength);
		end;
	end;
else
	RemoteEvent = Instance.new("RemoteEvent",script);
	RemoteFunction = Instance.new("RemoteFunction",script);
	BindableEvent = Instance.new("BindableEvent",script);
	BindableFunction = Instance.new("BindableFunction",script);
	RemoteEvent.Name,RemoteFunction.Name,BindableEvent.Name,BindableFunction.Name = RandomString(Config.RandomStringLength),RandomString(Config.RandomStringLength),RandomString(Config.RandomStringLength),RandomString(Config.RandomStringLength);
end;

function Connect(CallbackName : string ,ConnectionType : any ,CallbackFunction)
	if typeof(ConnectionType) == "string" then
		ConnectionType = ConnectionType:lower();
	end;
	if typeof(CallbackName) ~= "string" or not CallbackName then 
		return warn(ErrorInfo("Callback Name was not provided or was not a string!",debug.traceback("",2)));
	elseif (typeof(ConnectionType) ~= "string" and typeof(ConnectionType) ~= "number") or not ConnectionType then 
		return warn(ErrorInfo("ConnectionType was not provided or was not an accepted value!",debug.traceback("",2)));
	elseif not (table.find(Config.RemoteFuncNames,ConnectionType) or table.find(Config.RemoteEventNames,ConnectionType) or table.find(Config.BindableFuncNames,ConnectionType) or table.find(Config.BindableEventNames,ConnectionType)) then
		return warn(ErrorInfo("ConnectionType "..tostring(ConnectionType).." does not exist in the Config",debug.traceback("",2)));
	elseif not CallbackFunction or typeof(CallbackFunction) ~= "function" then
		return warn(ErrorInfo("CallbackFunction was not provided!",debug.traceback("",2)));
	end;
	if table.find(Config.RemoteFuncNames,ConnectionType) then
		Networker.RemoteFunctionCallbacks[CallbackName] = CallbackFunction;
	elseif table.find(Config.RemoteEventNames,ConnectionType) then
		Networker.RemoteEventCallbacks[CallbackName] = CallbackFunction;
	elseif table.find(Config.BindableFuncNames,ConnectionType) then
		Networker.BindableFunctionCallbacks[CallbackName] = CallbackFunction;
	elseif table.find(Config.BindableEventNames,ConnectionType) then
		Networker.BindableEventsCallbacks[CallbackName] = CallbackFunction;
	end;
end;

function Disconnect(CallbackName : string ,ConnectionType : any )
	if typeof(ConnectionType) == "string" then
		ConnectionType = ConnectionType:lower();
	end;
	if typeof(CallbackName) ~= "string" or not CallbackName then 
		return warn(ErrorInfo("CallbackName was not provided or was not a string!",debug.traceback(nil,2)));
	elseif (typeof(ConnectionType) ~= "string" and typeof(ConnectionType) ~= "number") or not ConnectionType then 
		return warn(ErrorInfo("ConnectionType was not provided or was not an accepted value!",debug.traceback(nil,2)));
	elseif not (table.find(Config.RemoteFuncNames,ConnectionType) or table.find(Config.RemoteEventNames,ConnectionType) or table.find(Config.BindableFuncNames,ConnectionType) or table.find(Config.BindableEventNames,ConnectionType)) then
		return warn(ErrorInfo("ConnectionType "..tostring(ConnectionType).." does not exist in the Config",debug.traceback(nil,2)));
	end;
	if table.find(Config.RemoteFuncNames,ConnectionType) then
		Networker.RemoteFunctionCallbacks[CallbackName] = nil;
	elseif table.find(Config.RemoteEventNames,ConnectionType) then
		Networker.RemoteEventCallbacks[CallbackName] = nil;
	elseif table.find(Config.BindableFuncNames,ConnectionType) then
		Networker.BindableFunctionCallbacks[CallbackName] = nil;
	elseif table.find(Config.BindableEventNames,ConnectionType) then
		Networker.BindableEventsCallbacks[CallbackName] = nil;
	end;
end;

Networker.Client = {};
Networker.Server = {};

if Networker.IsClient then

	Networker.Client.Connect = Connect;
	Networker.Client.Disconnect = Disconnect;


	function Networker.Client.FireServer(name,...)
		RemoteEvent:FireServer(name, ...);
	end;

	function Networker.Client.RequestServer(name,...)
		return RemoteFunction:InvokeServer(name,...);
	end;

	function Networker.Client.FireSelf(name,...)
		BindableEvent:Fire(name,...);
	end;

	function Networker.Client.RequestSelf(name,...)
		return BindableFunction:Invoke(name,...);
	end;

	RemoteEvent.OnClientEvent:Connect(function(name,...)
		local callbackfunction = Networker.RemoteEventCallbacks[name];
		if callbackfunction and typeof(callbackfunction) == "function" then
			callbackfunction(...);
		else
			local Log = name and "RemoteEvent: "..name..[[
			
				Logs Missed:
			
			]];
			if Log and ... then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			";
				end;
			end;
			warn(ErrorInfo("No callback provided on Client. Leaking signals will occur.",Log));
		end;
	end);

	RemoteFunction.OnClientInvoke = function(name,...)
		local callbackfunction = Networker.RemoteFunctionCallbacks[name];
		if callbackfunction and typeof(callbackfunction) == "function" then
			return callbackfunction(...);
		else
			local Log = name and "RemoteFunction: "..name..[[
			
				Logs Missed:
			
			]];
			if Log and ... then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			";
				end;
			end;
			warn(ErrorInfo("No callback provided on Client. Leaking signals will occur.",Log));
			return nil;
		end;
	end;

	BindableEvent.Event:Connect(function(name,...) 
		local callbackfunction = Networker.BindableEventsCallbacks[name];
		if callbackfunction and typeof(callbackfunction) == "function" then
			callbackfunction(...);
		else
			local Log = name and "BindableEvent: "..name..[[
			
				Logs Missed:
			
			]];
			if Log and ... then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			";
				end;
			end;
			warn(ErrorInfo("No callback provided on Client. Leaking signals will occur.",Log));
		end;
	end);

	BindableFunction.OnInvoke = function(name,...)
		local callbackfunction = Networker.BindableFunctionCallbacks[name];
		if callbackfunction and typeof(callbackfunction) == "function" then
			return callbackfunction(...);
		else
			local Log = name and "BindableFunction: "..name..[[
			
				Logs Missed:
			
			]];
			if Log and ... then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			";
				end;
			end;
			warn(ErrorInfo("No callback provided on Client. Leaking signals will occur.",Log));
			return nil;
		end;
	end;

	Networker.Client.Connect("MessWithExploitersBindableE",3,function()
		return;
	end);

	Networker.Client.Connect("MessWithExploitersBindableF",4,function()
		return;
	end);

	task.spawn(function()
		while true do
			task.wait();
			Networker.Client.FireServer("MessWithExploitersRE");
			Networker.Client.RequestServer("MessWithExploitersRF");
			Networker.Client.FireSelf("MessWithExploitersBindableE");
			Networker.Client.RequestSelf("MessWithExploitersBindableF");
		end;
	end);
else

	Networker.Server.Connect = Connect;
	Networker.Server.Disconnect = Disconnect;

	Networker.Server.Connect("MessWithExploitersRE",1,function()
		return;
	end);

	Networker.Server.Connect("MessWithExploitersRF",2,function()
		return;
	end);

	function Networker.Server.FireClient(Player,name,...)
		RemoteEvent:FireClient(Player,name,...);
	end;

	function Networker.Server.FireAllClients(name,...)
		RemoteEvent:FireAllClients(name,...);
	end;

	function Networker.Server.FireMultipleClients(Players,name,...)
		for _,Player:Player in Players do
			RemoteEvent:FireClient(Player,name,...);
		end;
	end;

	function Networker.Server.RequestClient(Player,name,...)
		return RemoteFunction:InvokeClient(Player,name,...);
	end;

	function Networker.Server.FireSelf(name,...)
		BindableEvent:Fire(name,...);
	end;

	function Networker.Server.RequestSelf(name,...)
		return BindableFunction:Invoke(name,...);
	end;

	RemoteEvent.OnServerEvent:Connect(function(Player,name,...)
		local callbackfunction = Networker.RemoteEventCallbacks[name];
		if callbackfunction and typeof(callbackfunction) == "function" then
			callbackfunction(Player, ...);
		else
			local Log = name and "RemoteEvent: "..name..[[
			
				Logs Missed:
			
			]];
			if Log and ... then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			";
				end;
			end;
			warn(ErrorInfo("No callback provided on Server. Leaking signals will occur.",Log));
		end;
	end);

	RemoteFunction.OnServerInvoke = function(Player,name,...)
		local callbackfunction = Networker.RemoteFunctionCallbacks[name];
		if callbackfunction  and typeof(callbackfunction) == "function" then
			return callbackfunction(Player,...);
		else
			local Log = name and "RemoteFunction: "..name..[[
			
				Logs Missed:
			
			]];
			if Log then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			"
				end;
			end;
			warn(ErrorInfo("No callback provided on Server. Leaking signals will occur.",Log));
			return nil;
		end;
	end;

	BindableEvent.Event:Connect(function(name,...)
		local callbackfunction = Networker.BindableEventsCallbacks[name];
		if callbackfunction and typeof(callbackfunction) == "function" then
			callbackfunction(...);
		else
			local Log = name and "BindableEvent: "..name..[[
			
				Logs Missed:
			
			]];
			if Log then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			";
				end;
			end;
			warn(ErrorInfo("No callback provided on Server. Leaking signals will occur.",Log));
		end;
	end);

	BindableFunction.OnInvoke = function(name,...)
		local callbackfunction = Networker.BindableFunctionCallbacks[name];
		if callbackfunction and typeof(callbackfunction) == "function" then
			return callbackfunction(...);
		else
			local Log = name and "BindableFunction: "..name..[[
			
				Logs Missed:
			
			]];
			if Log then
				for Index,Thing in next, {...} do
					Log = Log.."			["..tostring(Index).."] = "..tostring(Thing).." : "..tostring(typeof(Thing)).."\n			";
				end;
			end;
			warn(ErrorInfo("No callback provided on Server. Leaking signals will occur.",Log));
			return nil;
		end;
	end;

end;

-- Do NOT remove credits --
warn("Networker V.4.0.0 | Successfully loaded \n Owned by Geggo Studios \n Credits: \n Originally coded by Vozath \n Traceback system added by TheDarkheross \n Roblox UserId: 182409420 \n Discord UserId:492526161230954497");
-- Do NOT remove credits --

return Networker::{
	Client : {
		--[Connections]--
		Connect : (CallbackName : string ,ConnectionType :any ,CallbackFunction:any) -> nil;
		Disconnect : (CallbackName : string ,ConnectionType : any ) -> nil;
		--[Client]--
		FireServer : (name : string) -> nil;
		RequestServer : (name : string) -> any;
		FireSelf : (name : string) -> nil;
		RequestSelf : (name : string) -> any;
	};
	Server : {
		--[Connections]--
		Connect : (CallbackName : string ,ConnectionType :any ,CallbackFunction:any) -> nil;
		Disconnect : (CallbackName : string ,ConnectionType : any ) -> nil;
		--[Server]--
		FireSelf : (name : string) -> nil;
		RequestSelf : (name : string) -> any;
		FireClient : (Player : Player,name : string) -> nil;
		FireAllClients : (name : string) -> nil;
		FireMultipleClients : (Players : {[number] : Player},name : string) -> nil;
		RequestClient : (Player: Player,name : string) -> any;
	};
};
