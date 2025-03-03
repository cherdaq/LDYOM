ffi = require "ffi"
require "LDYOM.Scripts.baseNode"
class = require "LDYOM.Scripts.middleclass"

Node = bitser.registerClass(class("NodeTrainToTrain", BaseNode));
Node.static.mission = true;

Node.static.name = imgui.imnodes.getNodeIcon("func")..' '..ldyom.langt("CoreNodeGetTrainHandle");

function Node:initialize(id)
	BaseNode.initialize(self,id);
	self.type = 4;
	self.Pins = {
		[self.id+1] = BasePin:new(self.id+1,imgui.imnodes.PinType.number, 0, ffi.new("int[1]")),
		[self.id+2] = BasePin:new(self.id+2,imgui.imnodes.PinType.number, 1, ffi.new("int[1]")),
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
	
	imgui.imnodes.BeginStaticAttribute(self.id+1);
	local names = ldyom.namesTrains;
	imgui.Text(ldyom.langt("train"));
	imgui.SetNextItemWidth(150);
	imgui.ComboVecChars("",self.Pins[self.id+1].value,names);
	imgui.imnodes.EndStaticAttribute();
	
	imgui.imnodes.BeginOutputAttribute(self.id+2);
	imgui.Indent(80);
	imgui.Text(ldyom.langt("CoreHandleTrain"));
	imgui.imnodes.EndOutputAttribute();
	
	imgui.imnodes.EndNode();
	
end

function Node:play(data, mission)
	local train = self.Pins[self.id+1].value[0];
	ldyom.setLastNode(self.id);
	assert(mission.list_trains[train+1].missionTrain, "The train is not yet established or has already disappeared.");
	self.Pins[self.id+2].value[0] = getTrainRef(mission.list_trains[train+1].missionTrain);
end

ldyom.nodeEditor.addNodeClass("Train",Node);