<%@ page import="similarity.mapper.*"%>
<%@ page import="java.util.*"%>
<html>

    <head>
        <script type="" src="JavascriptFile.js"></script>
    </head>

    <body>
        <%
            System.out.println("HI");
            
            Question q1 = new Question();
            Question q2 = new Question();
            Mapper m = new Mapper("D:/Implementation/data/DMver1.owl");
            m.ReadOntology();
            String str[] = new String[2];

            str[0] = request.getParameter("question1");
            String marksString1 = request.getParameter("marks1");
            str[1] = request.getParameter("question2");
            String marksString2 = request.getParameter("marks2");

            System.out.println("Question1: " + str[0]);
            System.out.println("marks1: " + marksString1);
            System.out.println("Question2: " + str[1]);
            System.out.println("marks2: " + marksString2);

            int marks;
            int z = 0;
            NodeCapsule MappedNodes1[] = new NodeCapsule[100];
            NodeCapsule MappedNodes2[] = new NodeCapsule[100];
            int count1 = 0;
            int count2 = 0;

            while (z < 2) {
                if (z == 0) {
                    int noOfNodesMapped = 0;
                    NodeCapsule nodesMapped[] = new NodeCapsule[100];// assuming 100 node structure
                    String concepts[] = new String[100];//100 concepts

                    StringTokenizer st = new StringTokenizer(str[z], "?., ");//for tokenizing the question
                    int numOfWords = st.countTokens();//counts number of words
                    String a[] = new String[numOfWords];//array of token to store all the tokens.
                    boolean flag[] = new boolean[numOfWords];//Flag for encountered keywords
                    for (int i = 0; i < numOfWords; i++) {
                        flag[i] = true;
                    }
                    boolean isColored[] = new boolean[numOfWords];// to color keywords with red.
                    int i = 0;

                    while (st.hasMoreTokens()) {
                        a[i] = st.nextToken();// to fill the token array.
                        i++;
                    }

                    int windowStart, windowEnd; //windows used to implement ngram logic.
                    String questionSubstring, concept;
                    int pos[] = new int[10];
                    int i1 = 0;
                    for (i1 = 0; i1 < 10; i1++) {
                        pos[i1] = -1;
                    }
                    i1 = 0;
                    System.out.println("\n\nQuestion: " + str[z]);

                    for (int windowSize = numOfWords; windowSize > 0; windowSize--) {
                        //System.out.println("Window size: "+windowSize);
                        windowStart = 0;
                        windowEnd = windowSize;
                        //start of ngram logic
                        do {
                            questionSubstring = "";
                            //System.out.println("Start: "+windowStart+", End: "+windowEnd);
                            int pointer = 0;
                            for (pointer = windowStart; (pointer < windowEnd) && (flag[pointer] != false); pointer++) {
                                questionSubstring = questionSubstring.concat((" " + a[pointer])).trim();
                            }
                            //System.out.println(questionSubstring);
                            for (i = 0; i < m.totalAnnotationCount; i++) {
                                concept = m.conceptList[i].keyword;

                                if (concept.equalsIgnoreCase(questionSubstring)) {
                                    for (pointer = windowStart; pointer < windowEnd; pointer++) {
                                        flag[pointer] = false;
                                        isColored[pointer] = true;

                                    }
                                    concepts[noOfNodesMapped] = questionSubstring;
                                    nodesMapped[noOfNodesMapped] = m.conceptList[i].associatedNode;
                                    noOfNodesMapped++;
                                    pos[i1++] = i;
                                }
                            }
                            windowStart++;
                            windowEnd++;

                        } while (windowEnd <= numOfWords);
                    }

                    q1.nodesMapped = new NodeCapsule[noOfNodesMapped];
                    q1.test = new NodeCapsule[noOfNodesMapped];
                    q1.concepts = new String[noOfNodesMapped];
                    //q.question = new String[numOfWords];
                    q1.question1 = a;
                    //q.marks = marks;
                    q1.noOfNodesMapped = noOfNodesMapped;
                    for (i = 0; i < noOfNodesMapped; i++) {
                        q1.concepts[i] = concepts[i];
                        q1.nodesMapped[i] = nodesMapped[i];
                        q1.test[i] = nodesMapped[i];
                    }
                    q1.checkAncestors(m);

                    MappedNodes1 = q1.propogate(m);

                    count1 = q1.Mapcount;
                    //q1.plotGraph();

                    out.println("<br><table STYLE=\"position:absolute; TOP:50px; LEFT:600px;\"  align=center cellspacing=4 cellpadding=4>");
                    out.println("<tr></tr> <tr><td><center>  <font face=\"impact\" size=5>");
                    for (int x = 0; x < numOfWords; x++) {
                        if (isColored[x]) {
                            out.println("  <font color=\"red\" face=\"impact\" size=5>" + a[x]);
                        } else {
                            out.println("  <font color=\"black\" face=\"impact\" size=5>" + a[x]);
                        }

                    }
                    out.println("</font>    </tr></td>");
                    out.println("</table>");

                    out.println("<table STYLE=\"position:absolute; TOP:200px; LEFT:50px;\" cellspacing=4 cellpadding=1 border=1>");
                    if (noOfNodesMapped > 0) {

                        out.println("<tr>");
                        out.println("<td> <center><font face=\"impact\" size=5>Concept found </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Node mapped </font> </center></td>");
                        // out.println("<td> <center><font face=\"impact\" size=5>Ancestors found </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Parent </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Level </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Identity </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Path Followed </font> </center></td>");
                        out.println("</tr>");
                    }

                    for (i = 0; i < q1.noOfNodesMapped; i++) {
                        NodeCapsule temp = m.conceptList[pos[i]].associatedNode;
                        out.println("<tr>");
                        out.println("<td> <center><font face=\"impact\" size=3>" + q1.concepts[i] + "</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + q1.nodesMapped[i].name
                                + "</font> </center></td>");

                                        //  if(q1.ancestor[i]!=null)
                        //     out.println("<td> <center><font face=\"impact\" size=3>" + q1.ancestor[i].name + "</font> </center></td>");
                        //  else
                        //      out.println("<td> <center><font face=\"impact\" size=3>"+""+"</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + temp.parentName + "</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + temp.level + "</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + temp.identity + "</font> </center></td>");

                        out.println("<td>");

                        while (temp != null) {
                            out.println("<font>-->" + temp.name + "</font>");
                            temp = temp.parent;

                        }
                        out.println("</td>");

                        out.println("</tr>");
                    }

                    z++;
                } else {
                    int noOfNodesMapped = 0;
                    NodeCapsule nodesMapped[] = new NodeCapsule[1000];// assuming 100 node structure
                    String concepts[] = new String[1000];//100 concepts
                    System.out.println("str[z]: " + str[z]);
                    StringTokenizer st = new StringTokenizer(str[z], "?., ");//for tokenizing the question
                    int numOfWords = st.countTokens();//counts number of words
                    String a[] = new String[numOfWords];//array of token to store all the tokens.
                    boolean flag[] = new boolean[numOfWords];//Flag for encountered keywords
                    for (int i = 0; i < numOfWords; i++) {
                        flag[i] = true;
                    }
                    boolean isColored[] = new boolean[numOfWords];// to color keywords with red.
                    int i = 0;

                    while (st.hasMoreTokens()) {
                        a[i] = st.nextToken();// to fill the token array.
                        i++;
                    }

                    int windowStart, windowEnd; //windows used to implement ngram logic.
                    String questionSubstring, concept;
                    int i1 = 0;
                    int pos[] = new int[10];
                    for (i1 = 0; i1 < 10; i1++) {
                        pos[i1] = -1;
                    }
                    i1 = 0;
                    System.out.println("\n\nQuestion: " + str[z]);

                    for (int windowSize = numOfWords; windowSize > 0; windowSize--) {
                        //System.out.println("Window size: "+windowSize);
                        windowStart = 0;
                        windowEnd = windowSize;
                        //start of ngram logic
                        do {
                            questionSubstring = "";
                            //System.out.println("Start: "+windowStart+", End: "+windowEnd);
                            int pointer = 0;
                            for (pointer = windowStart; (pointer < windowEnd) && (flag[pointer] != false); pointer++) {
                                questionSubstring = questionSubstring.concat((" " + a[pointer])).trim();
                            }
                            //System.out.println(questionSubstring);
                            for (i = 0; i < m.totalAnnotationCount; i++) {
                                concept = m.conceptList[i].keyword;

                                if (concept.equalsIgnoreCase(questionSubstring)) {
                                    for (pointer = windowStart; pointer < windowEnd; pointer++) {
                                        flag[pointer] = false;
                                        isColored[pointer] = true;

                                    }
                                    concepts[noOfNodesMapped] = questionSubstring;
                                    nodesMapped[noOfNodesMapped] = m.conceptList[i].associatedNode;
                                    noOfNodesMapped++;
                                    pos[i1++] = i;
                                }
                            }
                            windowStart++;
                            windowEnd++;

                        } while (windowEnd <= numOfWords);
                    }

                    q2.nodesMapped = new NodeCapsule[noOfNodesMapped];
                    q2.test = new NodeCapsule[noOfNodesMapped];
                    q2.concepts = new String[noOfNodesMapped];
                    //q.question = new String[numOfWords];
                    q2.question1 = a;
                    //q.marks = marks;
                    q2.noOfNodesMapped = noOfNodesMapped;
                    for (i = 0; i < noOfNodesMapped; i++) {
                        q2.concepts[i] = concepts[i];
                        q2.nodesMapped[i] = nodesMapped[i];
                        q2.test[i] = nodesMapped[i];
                    }
                    q2.checkAncestors(m);

                    MappedNodes2 = q2.propogate(m);
                    count2 = q2.Mapcount;

                    out.println("<br><table STYLE=\"position:absolute; TOP:450px; LEFT:600px;\"  align=center cellspacing=4 cellpadding=4>");
                    out.println("<tr></tr> <tr><td><center>  <font face=\"impact\" size=5>");
                    for (int x = 0; x < numOfWords; x++) {
                        if (isColored[x]) {
                            out.println("  <font color=\"red\" face=\"impact\" size=5>" + a[x]);
                        } else {
                            out.println("  <font color=\"black\" face=\"impact\" size=5>" + a[x]);
                        }

                    }
                    out.println("</font>    </tr></td>");
                    out.println("</table>");

                    if (noOfNodesMapped > 0) {
                        out.println("<table STYLE=\"position:absolute; TOP:600px; LEFT:50px;\" cellspacing=4 cellpadding=1 border=1>");
                        out.println("<tr>");
                        out.println("<td> <center><font face=\"impact\" size=5>Concept found </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Node mapped </font> </center></td>");
                        //out.println("<td> <center><font face=\"impact\" size=5>Ancestors found </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Parent </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Level </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Identity </font> </center></td>");
                        out.println("<td> <center><font face=\"impact\" size=5>Path Followed </font> </center></td>");

                        out.println("</tr>");
                    }

                    for (i = 0; i < q2.noOfNodesMapped; i++) {
                        NodeCapsule temp = m.conceptList[pos[i]].associatedNode;
                        out.println("<tr>");
                        out.println("<td> <center><font face=\"impact\" size=3>" + q2.concepts[i] + "</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + q2.nodesMapped[i].name
                                + "</font> </center></td>");

                                        //if(q2.ancestor[i]!=null)
                        // out.println("<td> <center><font face=\"impact\" size=3>" + q2.ancestor[i].name + "</font> </center></td>");
                        //else
                        // out.println("<td> <center><font face=\"impact\" size=3>"+""+"</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + temp.parentName + "</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + temp.level + "</font> </center></td>");
                        out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + temp.identity + "</font> </center></td>");

                        out.println("<td>");

                        while (temp != null) {
                            out.println("<font>-->" + temp.name + "</font>");
                            temp = temp.parent;

                        }
                        out.println("</td>");
                        out.println("</tr>");

                    }

                    out.println("</table>");
                    z++;
                }

            }
            NodeCapsule a[] = new NodeCapsule[count1];
            for (int k1 = 0; k1 < count1; k1++) {
                a[k1] = MappedNodes1[k1];
            }
            NodeCapsule b[] = new NodeCapsule[count2];
            for (int k2 = 0; k2 < count2; k2++) {
                b[k2] = MappedNodes2[k2];
            }

            float sim[];
            sim = q1.similarity(a, b);
            out.println("<table STYLE=\"position:absolute; TOP:850px; LEFT:200px;\" cellspacing=4 cellpadding=1 border=1>");
            out.println("<tr>");
            out.println("<td> <center><font face=\"impact\" size=5>NODES MAPPED IN Q1 </font> </center></td>");
            out.println("<td> <center><font face=\"impact\" size=5>NODES MAPPED IN Q2 </font> </center></td>");
            out.println("<td> <center><font face=\"impact\" size=5>FORMULA 1 </font> </center></td>");
            out.println("<td> <center><font face=\"impact\" size=5>FORMULA 2 </font> </center></td>");
            out.println("<td> <center><font face=\"impact\" size=5>FORMULA 3 </font> </center></td>");
            out.println("<td> <center><font face=\"impact\" size=5>FORMULA 4 </font> </center></td>");
            out.println("</tr>");
            for (int i = 0; i < a.length || i < b.length; i++) {
                out.println("<tr>");
                if (i < a.length) {
                    out.println("<td> <center><font color=\"blue\"face=\"impact\" size=3>" + a[i].name + "</font> </center></td>");
                } else {
                    out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + "" + "</font> </center></td>");
                }
                if (i < b.length) {
                    out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + b[i].name + "</font> </center></td>");
                } else {
                    out.println("<td> <center><font color=\"red\" face=\"impact\" size=3>" + "" + "</font> </center></td>");
                }
                if (i == (a.length / 2)) {
                    out.println("<td> <center><font face=\"impact\" size=3>" + sim[0] * 100 + "</font> </center></td>");
                } else {
                    out.println("<td> <center><font face=\"impact\" size=3>" + "" + "</font> </center></td>");
                }
                if (i == (a.length / 2)) {
                    out.println("<td> <center><font face=\"impact\" size=3>" + sim[1] * 100 + "</font> </center></td>");
                } else {
                    out.println("<td> <center><font face=\"impact\" size=3>" + "" + "</font> </center></td>");
                }
                if (i == (a.length / 2)) {
                    out.println("<td> <center><font face=\"impact\" size=3>" + sim[2] * 100 + "</font> </center></td>");
                } else {
                    out.println("<td> <center><font face=\"impact\" size=3>" + "" + "</font> </center></td>");
                }
                if (i == (a.length / 2)) {
                    out.println("<td> <center><font face=\"impact\" size=3>" + sim[3] * 100 + "</font> </center></td>");
                } else {
                    out.println("<td> <center><font face=\"impact\" size=3>" + "" + "</font> </center></td>");
                }
                out.println("</tr>");
            }
        %>