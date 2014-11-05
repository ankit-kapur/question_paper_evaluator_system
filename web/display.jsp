<%-- 
    Document   : display
    Created on : 6 Apr, 2011, 7:24:11 PM
    Author     : vaio
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="similarity.mapper.*" %>
<%@ page import="java.util.*" %>
<%
 Mapper m = new Mapper("D:/Implementation/data/DMver1.owl");
 m.ReadOntology();
  out.println("<table STYLE=\"position:absolute; TOP:50px; LEFT:50px;\" cellspacing=2 cellpadding=1 border=1>");
            out.println("<tr>");
                out.println("<td> <center><font face=\"impact\" size=4>Concept</font> </center></td>");
                out.println("<td> <center><font face=\"impact\" size=4>Associated Node</font> </center></td>");
                out.println("<td><center><font face=\"impact\" size=4>Identity</font> </center></td>");
                out.println("<td><center><font face=\"impact\" size=4>Level</font> </center></td>");
                out.println("<td><center><font face=\"impact\" size=4>Parent Name</font> </center></td>");
                
                out.println("<td><center><font face=\"impact\" size=4>No.of Annotations</font> </center></td>");
              //  out.println("<td><center><font face=\"impact\" size=4>Annotations</font> </center></td>");
                
                out.println("<td><center><font face=\"impact\" size=4>No.of Subclasses</font> </center></td>");
               // out.println("<td><center><font face=\"impact\" size=4>Subclasses</font></center></td>");

            out.println("</tr>");


    

 for(int i=0; i<m.totalAnnotationCount; i++)
        {
           out.println("<tr>");
            if(m.conceptList[i]!=null)
            {
                 out.println ("<td><center><font  size=4>"+m.conceptList[i].keyword+"</font></center></td>");
                 out.println ("<td><center><font  size=4>"+m.conceptList[i].associatedNode.name+"</font></center></td>");
                 out.println ("<td><center><font  size=4>"+m.conceptList[i].associatedNode.identity+"</font></center></td>");
                 out.println ("<td><center><font  size=4>"+m.conceptList[i].associatedNode.level+"</font></center></td>");
                 out.println ("<td><center><font  size=4>"+m.conceptList[i].associatedNode.parentName+"</font></center></td>");

                 
                 if(m.conceptList[i].keyword.equalsIgnoreCase(m.conceptList[i].associatedNode.name))
                 {
                 out.println ("<td><center><font  size=4>"+m.conceptList[i].associatedNode.numOfAnnotations+"</font></center></td>");
                // out.println ("<td><center><font  size=5>"+m.conceptList[i].associatedNode.annotation[j]+"</font></center></td>");
                }
                 else
                  {
                     out.println ("<td><center><font  size=2>"+"It's an annotation"+"</font></center></td>");
                  }
                 out.println ("<td><center><font  size=4>"+m.conceptList[i].associatedNode.numOfSubclasses+"</font></center></td>");
                // out.println ("<td><center><font  size=5>"+m.conceptList[i].associatedNode.Subclass[j]+"</font></center></td>");
                 
             }
        }
        
%>
