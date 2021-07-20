ffi = require "ffi"
require "LDYOM.Scripts.baseNode"
class = require "LDYOM.Scripts.middleclass"

Node = bitser.registerClass(class("NodeHasGotWeapon", BaseNode));
Node.static.mission = true;

Node.static.name = imgui.imnodes.getNodeIcon("fork")..' '..ldyom.langt("CoreNodeHasGotWeapon");

function Node:initialize(id)
	BaseNode.initialize(self,id);
	self.type = 1;
	self.Pins = {
		[self.id+2] = BasePin:new(self.id+2,imgui.imnodes.PinType.number, 0, ffi.new("int[1]")),
		[self.id+3] = BasePin:new(self.id+3,imgui.imnodes.PinType.number, 0, ffi.new("int[1]")),
		[self.id+4] = BasePin:new(self.id+4,imgui.imnodes.PinType.boolean, 1, ffi.new("bool[1]")),
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
	
	imgui.imnodes.BeginInputAttribute(self.id+3);
	if not self.Pins[self.id+3].link then
		ldyom.selectWeapon(ldyom.langt("weapon"), self.Pins[self.id+3].value);
	else
		imgui.Text(ldyom.langt("weapon"));
	end
	imgui.imnodes.EndInputAttribute();
	
	imgui.imnodes.BeginOutputAttribute(self.id+4);
	imgui.Indent(130);
	imgui.Text(ldyom.langt("result"));
	imgui.imnodes.EndOutputAttribute();
	
	imgui.imnodes.EndNode();
	
end

function Node:play(data, mission)
		
	local ped = self:getPinValue(self.id+2,data,mission)[0];
	local weapon = self:getPinValue(self.id+3,data,mission)[0];
	assert(callOpcode(0x056D, {{ped,"int"}}), "Not found ped");
	ldyom.setLastNode(self.id);
	
	local result = self.Pins[self.id+4].value;
	
	result[0] = callOpcode(0x0491, {{ped,"int"}, {weapon,"int"}});
end

ldyom.nodeEditor.addNodeClass("Ped",Node);