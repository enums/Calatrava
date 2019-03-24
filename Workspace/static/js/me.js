var currentPosition,timer;  
var currentPosition,timer;  
function toTop() {
	timer = setInterval("stepToTop()",0);
}
function stepToTop(){  
    currentPosition = document.documentElement.scrollTop || document.body.scrollTop;   
    currentPosition -= document.body.scrollTop / 12;  
    if(currentPosition>0) {  
        window.scrollTo(0,currentPosition);  
    } else {  
        window.scrollTo(0,0);  
        clearInterval(timer);  
    }  
}  

function getMsgToDo(url, foo) {
	var xmlhttp;
	if (window.XMLHttpRequest) {
		xmlhttp = new XMLHttpRequest();
	} else {
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			foo(xmlhttp.responseText);
		}
	}
	xmlhttp.open("GET",url,true);
	xmlhttp.send();
}

function postMsgToDo(url, body, foo) {
	var xmlhttp;
	if (window.XMLHttpRequest) {
		xmlhttp = new XMLHttpRequest();
	} else {
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
			foo(xmlhttp.responseText);
		}
	}
	xmlhttp.open("POST",url,true);
	xmlhttp.send(body);
}

function getMsgToChangeHTML(url, id) {
	getMsgToDo(url, function(text) {
		get(id).innerHTML=text;
	});
} 

function _posts_love(pid) {
	getMsgToDo("/api/posts/love?pid=" + pid, function(text) {
		alert(text)
	})
}

function _corpus_love(pid) {
	getMsgToDo("/api/corpus/love?cpid=" + pid, function(text) {
		alert(text)
	})
}

function _posts_comment(pid, name, email, comment, v_id, v_a, onSuccess, onFailed) {
	var obj = {
		pid: pid,
		name: name,
		email: email,
		comment: comment,
		v_id: v_id,
		v_a: v_a,
	};
	postMsgToDo("/api/posts/comment", JSON.stringify(obj), function(text) {
		alert(text)
		if (text == "发表成功！") {
			onSuccess();
		} else {
			onFailed();
		}
	})
}

function _corpus_comment(cpid, name, email, comment, v_id, v_a, onSuccess, onFailed) {
	var obj = {
		cpid: cpid,
		name: name,
		email: email,
		comment: comment,
		v_id: v_id,
		v_a: v_a,
	};
	postMsgToDo("/api/corpus/comment", JSON.stringify(obj), function(text) {
		alert(text)
		if (text == "发表成功！") {
			onSuccess();
		} else {
			onFailed();
		}
	})
}

function _message(name, email, comment, v_id, v_a, onSuccess, onFailed) {
	var obj = {
		name: name,
		email: email,
		comment: comment,
		v_id: v_id,
		v_a: v_a,
	};
	postMsgToDo("/api/message", JSON.stringify(obj), function(text) {
		alert(text)
		if (text == "发表成功！") {
			onSuccess();
		} else {
			onFailed();
		}
	})
}

function _getVerification(onSuccess) {
	getMsgToDo("/api/verification", onSuccess)
}

function _setReferFloor(floor) {
	$("#comment").val("!*<引用 " + floor + " 楼>*!\n");
	location = "#comment";
}

function setCookie(cname,cvalue)
{
  	var d = new Date();
  	var hours = 24 * 7 * 365;
	d.setHours(d.getHours() + hours);
	document.cookie = cname + "=" + cvalue + "; expires=" + d.toGMTString();
}
 
function getCookie(cname)
{
	var name = cname + "=";
	var ca = document.cookie.split(';');
	for(var i=0; i<ca.length; i++) 
	{
		var c = ca[i].trim();
		if (c.indexOf(name)==0) return c.substring(name.length,c.length);
	}
	return "";
}

