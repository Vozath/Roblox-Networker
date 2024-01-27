local Config = {};

Config.FakeNetworkObjectsAmount = 5;
Config.RandomStringLength = 125;

Config.RemoteEventNames = {
	"remotee";
	"remoteevent";
	"revent";
	"re";
	1; --DO NOT REMOVE,USED INTERNALLY
};

Config.RemoteFuncNames = {
	"remotefunction";
	"remotef";
	"remotefunc";
	"rfunction";
	"rf";
	2; --DO NOT REMOVE,USED INTERNALLY
};

Config.BindableEventNames = {
	"bindablee";
	"bindableevent";
	"bevent";
	"be";
	3; --DO NOT REMOVE,USED INTERNALLY
};

Config.BindableFuncNames = {
	"bindablef";
	"bindablefunc";
	"bindablefunction";
	"bfunction";
	"bf";
	4; --DO NOT REMOVE,USED INTERNALLY
};

return Config;
