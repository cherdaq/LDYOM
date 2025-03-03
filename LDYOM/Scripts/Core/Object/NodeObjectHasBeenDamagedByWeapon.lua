ffi = require "ffi"
require "LDYOM.Scripts.baseNode"
class = require "LDYOM.Scripts.middleclass"

Node = bitser.registerClass(class("NodeObjectHasBeenDamagedByWeapon", BaseNode));
Node.static.mission = true;

Node.static.name = imgui.imnodes.getNodeIcon("fork")..' '..ldyom.langt("CoreNodeObjectHasBeenDamagedByWeapon");

function Node:initialize(id)
	BaseNode.initialize(self,id);
	self.type = 1;
	self.Pins = {
		[self.id+1] = BasePin:new(self.id+1,imgui.imnodes.PinType.number, 0, ffi.new("int[1]")),
		[self.id+3] = BasePin:new(self.id+3,imgui.imnodes.PinType.number, 0, ffi.new("int[1]")),
		[self.id+2] = BasePin:new(self.id+2,imgui.imnodes.PinType.boolean, 1, ffi.new("bool[1]")),
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
	
	imgui.imnodes.BeginInputAttribute(self.id+1);
	imgui.Text(ldyom.langt("CoreHandleObject"));
	imgui.imnodes.EndInputAttribute();
	
	imgui.imnodes.BeginInputAttribute(self.id+3);
	if not self.Pins[self.id+3].link then
		ldyom.selectWeapon(ldyom.langt("weapon"), self.Pins[self.id+3].value);
	else
		imgui.Text(ldyom.langt("weapon"));
	end
	imgui.imnodes.EndInputAttribute();
	
	imgui.imnodes.BeginOutputAttribute(self.id+2);
	imgui.Indent(170);
	imgui.Text(ldyom.langt("result"));
	imgui.imnodes.EndOutputAttribute();
	
	imgui.imnodes.EndNode();
	
end

function Node:play(data, mission)
	local object = self:getPinValue(self.id+1,data,mission)[0];
	local weapon = self:getPinValue(self.id+3,data,mission)[0];
	ldyom.setLastNode(self.id);
	assert(callOpcode(0x03CA, {{object,"int"}}), "Not found object");
	
	local result = self.Pins[self.id+2].value;
	
	result[0] = callOpcode(0x08FF, {{object,"int"}, {weapon,"int"}});
end

ldyom.nodeEditor.addNodeClass("Object",Node);