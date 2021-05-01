ffi = require "ffi"
require "LDYOM.Scripts.baseNode"
class = require "LDYOM.Scripts.middleclass"

Node = bitser.registerClass(class("NodeIsInArea", BaseNode));
Node.static.mission = true;

Node.static.name = imgui.imnodes.getNodeIcon("fork")..' '..ldyom.langt("CoreNodeIsInArea");

function Node:initialize(id)
	BaseNode.initialize(self,id);
	self.type = 1;
	self.three = ffi.new("bool[1]",false);
	local x = ffi.new("float[1]");
	local y = ffi.new("float[1]");
	local z = ffi.new("float[1]");
	callOpcode(0x00A0, {{PLAYER_PED,"ped"}, {x,"float*"}, {y,"float*"}, {z,"float*"}});
	self.Pins = {
		[self.id+2] = BasePin:new(self.id+2,imgui.imnodes.PinType.number, 0, ffi.new("int[1]")),
		[self.id+3] = BasePin:new(self.id+3,imgui.imnodes.PinType.number, 0, ffi.new("float[1]",x[0])),
		[self.id+4] = BasePin:new(self.id+4,imgui.imnodes.PinType.number, 0, ffi.new("float[1]",y[0])),
		[self.id+5] = BasePin:new(self.id+5,imgui.imnodes.PinType.number, 0, ffi.new("float[1]",z[0])),
		[self.id+6] = BasePin:new(self.id+6,imgui.imnodes.PinType.number, 0, ffi.new("float[1]",x[0])),
		[self.id+7] = BasePin:new(self.id+7,imgui.imnodes.PinType.number, 0, ffi.new("float[1]",y[0])),
		[self.id+8] = BasePin:new(self.id+8,imgui.imnodes.PinType.number, 0, ffi.new("float[1]",z[0])),
		[self.id+9] = BasePin:new(self.id+9,imgui.imnodes.PinType.boolean, 0, ffi.new("bool[1]")),
		[self.id+10] = BasePin:new(self.id+10,imgui.imnodes.PinType.boolean, 1, ffi.new("bool[1]")),
	};
end

function Node:draw()
	imgui.imnodes.BeginNode(self.id,self.type)
	
	imgui.imnodes.BeginNodeTitleBar();
	imgui.Text(self.class.static.name);
	if ldyom.getLastNode() == self.id then
		imgui.SameLine(0,0);
		imgui.TextColored(imgui.ImVec4.new(1.0,0.0,0.0,1.0)," \xef\x86\x88");
	end
	imgui.imnodes.EndNodeTitleBar();
	
	imgui.imnodes.BeginInputAttribute(self.id+2);
	imgui.Text(ldyom.langt("ped"));
	imgui.imnodes.EndInputAttribute();
	
	imgui.imnodes.BeginStaticAttribute(self.id+12);
	imgui.ToggleButton("3D", self.three);
	imgui.imnodes.EndStaticAttribute();
	
	imgui.imnodes.BeginInputAttribute(self.id+3);
	imgui.Text("x1");
	if not self.Pins[self.id+3].link then
		imgui.SetNextItemWidth(200);
		imgui.InputFloat("", self.Pins[self.id+3].value);
	end
	imgui.imnodes.EndInputAttribute();
	
	imgui.imnodes.BeginInputAttribute(self.id+4);
	imgui.Text("y1");
	if not self.Pins[self.id+4].link then
		imgui.SetNextItemWidth(200);
		imgui.InputFloat("", self.Pins[self.id+4].value);
	end
	imgui.imnodes.EndInputAttribute();
	
	if self.three[0] then
		imgui.imnodes.BeginInputAttribute(self.id+5);
		imgui.Text("z1");
		if not self.Pins[self.id+5].link then
			imgui.SetNextItemWidth(200);
			imgui.InputFloat("", self.Pins[self.id+5].value);
		end
		imgui.imnodes.EndInputAttribute();
	end
	
	imgui.imnodes.BeginStaticAttribute(self.id+13);
	if imgui.Button(ldyom.langt("playerCoordinates"), imgui.ImVec2:new(200,20)) then
		callOpcode(0x00A0, {{PLAYER_PED,"ped"}, {self.Pins[self.id+3].value,"float*"}, {self.Pins[self.id+4].value,"float*"}, {self.Pins[self.id+5].value,"float*"}});
	end
	imgui.imnodes.EndStaticAttribute();
	
	imgui.imnodes.BeginInputAttribute(self.id+6);
	imgui.Text("x2");
	if not self.Pins[self.id+6].link then
		imgui.SetNextItemWidth(200);
		imgui.InputFloat("", self.Pins[self.id+6].value);
	end
	imgui.imnodes.EndInputAttribute();
	
	imgui.imnodes.BeginInputAttribute(self.id+7);
	imgui.Text("y2");
	if not self.Pins[self.id+7].link then
		imgui.SetNextItemWidth(200);
		imgui.InputFloat("", self.Pins[self.id+7].value);
	end
	imgui.imnodes.EndInputAttribute();
	
	if self.three[0] then
		imgui.imnodes.BeginInputAttribute(self.id+8);
		imgui.Text("z2");
		if not self.Pins[self.id+8].link then
			imgui.SetNextItemWidth(200);
			imgui.InputFloat("", self.Pins[self.id+8].value);
		end
		imgui.imnodes.EndInputAttribute();
	end
	
	imgui.imnodes.BeginStaticAttribute(self.id+14);
	if imgui.Button(ldyom.langt("playerCoordinates"), imgui.ImVec2:new(200,20)) then
		callOpcode(0x00A0, {{PLAYER_PED,"ped"}, {self.Pins[self.id+6].value,"float*"}, {self.Pins[self.id+7].value,"float*"}, {self.Pins[self.id+8].value,"float*"}});
	end
	imgui.imnodes.EndStaticAttribute();
	
	imgui.imnodes.BeginInputAttribute(self.id+9);
	if not self.Pins[self.id+9].link then
		imgui.SetNextItemWidth(200);
		imgui.ToggleButton(ldyom.langt("sphere"), self.Pins[self.id+9].value);
	else
		imgui.Text(ldyom.langt("sphere"));
	end
	imgui.imnodes.EndInputAttribute();
	
	imgui.imnodes.BeginOutputAttribute(self.id+10);
	imgui.Indent(130);
	imgui.Text(ldyom.langt("result"));
	imgui.imnodes.EndOutputAttribute();
	
	imgui.imnodes.EndNode();
	
end

function Node:play(data, mission)
		
	local ped = self:getPinValue(self.id+2,data,mission)[0];
	local x1 = self:getPinValue(self.id+3,data,mission)[0];
	local y1 = self:getPinValue(self.id+4,data,mission)[0];
	local z1 = self:getPinValue(self.id+5,data,mission)[0];
	local x2 = self:getPinValue(self.id+6,data,mission)[0];
	local y2 = self:getPinValue(self.id+7,data,mission)[0];
	local z2 = self:getPinValue(self.id+8,data,mission)[0];
	local sphere = self:getPinValue(self.id+9,data,mission)[0];
	assert(callOpcode(0x056D, {{ped,"int"}}), "Not found ped");
	ldyom.setLastNode(self.id);
	
	local result = self.Pins[self.id+10].value;
	
	if self.three[0] then
		result[0] = callOpcode(0x00A4, {{ped,"int"}, {x1,"float"}, {y1,"float"}, {z1,"float"}, {x2,"float"}, {y2,"float"}, {z2,"float"}, {sphere,"bool"}});
	else
		result[0] = callOpcode(0x00A3, {{ped,"int"}, {x1,"float"}, {y1,"float"}, {x2,"float"}, {y2,"float"}, {sphere,"bool"}});
	end
end

ldyom.nodeEditor.addNodeClass("Ped",Node);