var items = fl.getDocumentDOM().library.items;
for(var i=0;i<items.length;i++)
{
	fl.trace(items[i].itemType);
	if(items[i].itemType == "bitmap")
	{
		var arr = items[i].name.split(".");
		if(!fl.getDocumentDOM().library.itemExists(arr[0]))
		{
			fl.trace(arr[0]);
			//如果不存在，则生成一个。
			fl.getDocumentDOM().library.addNewItem("movie clip",arr[0]);
			fl.getDocumentDOM().library.editItem(arr[0]);
			fl.getDocumentDOM().library.addItemToDocument({x:0,y:0},items[i].name);
			var el = fl.getDocumentDOM().getTimeline().layers[0].frames[0].elements[0];
			el.x = el.y = 0;
		}
	}
}
///*
items = fl.getDocumentDOM().library.items;
var docName = fl.getDocumentDOM().name;
fl.trace(docName);
var arr1 = docName.split(".");
//arr1[0] = 'Animation';

for(var j = 0;j<items.length;j++)
{
	flash.trace(items[j].name);
	if(items[j].itemType == "movie clip")
	{
		items[j].linkageExportForAS = true;
		items[j].linkageExportInFirstFrame = true;
		items[j].linkageClassName = "com.hurrygames.landGrabbers.swc."+arr1[0]+".MovieC"+items[j].name;
	}
}//*/