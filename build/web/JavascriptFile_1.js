var xmlHttp //the XHR (XMLHttpRequest object)

function searchConcepts(str1, marks1, str2, marks2)
{
    if (str1.length > 0 && str2.length > 0)
    {
        xmlHttp = GetXmlHttpObject(stateChanged);  //to retrieve XHR object

        str1 = encodeURIComponent(str1);
        marks1 = encodeURIComponent(marks1);
        str2 = encodeURIComponent(str2);
        marks2 = encodeURIComponent(marks2);

        xmlHttp.open("POST", "simtwo.jsp", true);
        xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlHttp.send("question1=" + str1 + "&marks1=" + marks1 + "&question2=" + str2 + "&marks2=" + marks2);

//        var url = "simtwo.jsp?question1=" + str1 + "&marks1=" + marks1 + "&question2=" + str2 + "&marks2=" + marks2   //constructing the url to invoke for this req
//        xmlHttp.open("GET", url, true)  //open() and send() dispatch req to server
//        xmlHttp.send(null)  //parameter already tied to URL and hence null arg for send()
    }
    else
    {
        document.getElementById("JspFromHere").innerHTML = "";
    }

}

function displayConcept()
{
    var url = "display.jsp?"
    xmlHttp = GetXmlHttpObject(stateChanged)  //to retrieve XHR object
    xmlHttp.open("GET", url, true)  //open() and send() dispatch req to server
    xmlHttp.send(null)  //parameter already tied to URL and hence null arg for send()

}
function graph()
{
    var url = "displayGraph.jsp?"
    xmlHttp = GetXmlHttpObject(stateChanged)  //to retrieve XHR object
    xmlHttp.open("GET", url, true)  //open() and send() dispatch req to server
    xmlHttp.send(null)  //parameter already tied to URL and hence null arg for send()
}
/*This is the callback function that is invoked by server when response is ready */
function stateChanged()
{

    if (xmlHttp.readyState == 4 || xmlHttp.readyState == "complete")
    {
        alert('Hi ' + xmlHttp.responseText);
        document.getElementById("JspFromHere").innerHTML = xmlHttp.responseText;

    }
}


/* This function retrives the XHR object */
function GetXmlHttpObject(handler)
{
    var objXmlHttp = null

    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        objXmlHttp = new XMLHttpRequest();
    } else if (navigator.userAgent.indexOf("Opera") >= 0) {
        alert("This example doesn't work in Opera")
        return
    } else if (navigator.userAgent.indexOf("MSIE") >= 0) {
        var strName = "Msxml2.XMLHTTP"
        if (navigator.appVersion.indexOf("MSIE 5.5") >= 0) {
            strName = "Microsoft.XMLHTTP"
        }
        try {
            objXmlHttp = new ActiveXObject(strName)
            objXmlHttp.onreadystatechange = handler
        }
        catch (e) {
            alert("Error. Scripting for ActiveX might be disabled")
            return
        }
    } else if (navigator.userAgent.indexOf("Mozilla") >= 0) {
        objXmlHttp = new XMLHttpRequest()
        objXmlHttp.onload = handler
        objXmlHttp.onerror = handler
    }

    return objXmlHttp
}
