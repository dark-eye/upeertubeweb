
WorkerScript.onMessage =  function(message) {
	var list = message.inData;
	var retList = [];
	for(var i in list) {
		if(message.searchTerm == "" || list[i].name && list[i].name.match(new RegExp(message.searchTerm))) {
			retList.push(list[i]);
		}
	}
	 var results =retList;
	 WorkerScript.sendMessage({reply: results});
}

 
 
