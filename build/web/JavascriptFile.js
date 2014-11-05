var xmlHttp //the XHR (XMLHttpRequest object)

function searchConcepts(str1, marks1,str2,marks2)
{
	if (str1.length >0&&str2.length>0)
	 {
             var url
            
                    
                url="simtwo.jsp?question1=" + str1 + "&marks1=" + marks1 + "&question2=" + str2 + "&marks2=" + marks2   //constructing the url to invoke for this req
              
             xmlHttp=GetXmlHttpObject(stateChanged)  //to retrieve XHR object
		xmlHttp.open("GET", url , true)  //open() and send() dispatch req to server
		xmlHttp.send(null)  //parameter already tied to URL and hence null arg for send()
	}
	else
	{
		document.getElementById("JspFromHere").innerHTML=""
                
	}
   
}
function displayConcept()
{
    var url="display.jsp?"
     xmlHttp=GetXmlHttpObject(stateChanged)  //to retrieve XHR object
     xmlHttp.open("GET", url , true)  //open() and send() dispatch req to server
     xmlHttp.send(null)  //parameter already tied to URL and hence null arg for send()

}
function graph()
{
    var url="displayGraph.jsp?"
     xmlHttp=GetXmlHttpObject(stateChanged)  //to retrieve XHR object
     xmlHttp.open("GET", url , true)  //open() and send() dispatch req to server
     xmlHttp.send(null)  //parameter already tied to URL and hence null arg for send()
}
/*This is the callback function that is invoked by server when response is ready */
function stateChanged()
{
    
  if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
	{
		document.getElementById("JspFromHere").innerHTML=xmlHttp.responseText;
               
	}
}


/* This function retrives the XHR object */
function GetXmlHttpObject(handler)
{
var objXmlHttp=null

if (navigator.userAgent.indexOf("Opera")>=0)
{
alert("This example doesn't work in Opera")
return
}
if (navigator.userAgent.indexOf("MSIE")>=0)
{
var strName="Msxml2.XMLHTTP"
if (navigator.appVersion.indexOf("MSIE 5.5")>=0)
{
strName="Microsoft.XMLHTTP"
}
try
{
objXmlHttp=new ActiveXObject(strName)
objXmlHttp.onreadystatechange=handler
return objXmlHttp
}
catch(e)
{
alert("Error. Scripting for ActiveX might be disabled")
return
}
}
if (navigator.userAgent.indexOf("Mozilla")>=0)
{
objXmlHttp=new XMLHttpRequest()
objXmlHttp.onload=handler
objXmlHttp.onerror=handler
return objXmlHttp
}
}
