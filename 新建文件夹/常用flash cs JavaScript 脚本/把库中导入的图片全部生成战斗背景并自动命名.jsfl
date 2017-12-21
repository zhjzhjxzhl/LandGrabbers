var items = fl.getDocumentDOM().library.items;
for(var i=0;i<items.length;i++)
{
	flash.trace(items[i].itemType);
	if(items[i].itemType == "bitmap")
	{
		var arr = items[i].name.split(".");
		if(!fl.getDocumentDOM().library.itemExists(arr[0]))
		{
			//如果不存在，则生成一个。
			fl.getDocumentDOM().library.addNewItem("movie clip",arr[0]);
			fl.getDocumentDOM().library.editItem(arr[0]);
			fl.getDocumentDOM().library.addItemToDocument({x:380,y:285},items[i].name);
			var el = fl.getDocumentDOM().getTimeline().layers[0].frames[0].elements[0];
			el.x = el.y = 0;
		}
	}
}