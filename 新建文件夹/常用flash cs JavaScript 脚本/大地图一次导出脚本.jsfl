var items = fl.getDocumentDOM().library.items;
for(var i=0;i<items.length;i++)
{
	if(items[i].itemType == "movie clip")
	{
		items[i].linkageExportForAS = false;
	}
}
var s1 = fl.getDocumentDOM().name;
fl.trace("导出文件:"+s1);

for(var k=0;k<items.length;k++)
{
	if(items[k].name)
	{
		var s = items[k].name;
		var arr = s.split("_");
		arr.pop();
		var path1 = arr.join("/");
		var rootPath = "file:///D|/SWF/";
		//if((s.indexOf("weapon")!=-1)||(s.indexOf("role")!=-1)||(s.indexOf("effect")!=-1)||(s.indexOf("battle")!=-1)||(s.indexOf("Map_Animation")!=-1))
		{
			if(!fl.fileExists(rootPath+path1+"/"))
			{
				FLfile.createFolder(rootPath+path1+"/");
			}
			fl.trace(s);
			items[k].exportSWF(rootPath+path1+"/"+items[k].name+".swf");
		}
	}
}